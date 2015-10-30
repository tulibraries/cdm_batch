require "etd_loader"
require "form"
require 'faraday'
require 'faraday_middleware'
require 'mime-types'

module CdmBatch
  class FormFiller
    attr_reader :etds, :form

    def initialize(metadata_path, form_config_path, credentials={})
      @etds = CdmBatch::ETDLoader.new(metadata_path)
      @form = CdmBatch::Form.new(form_config_path, form_url=nil)
      @creds = credentials
    end

    def upload_batch
      @etds.data.each do |record|
        response submit_single_record record
        if response.body.includes?("The item was not added to the pending queue.")
          #log failure - Add csv data to file? 
        end
      end
    end

    def submit_single_record(record)
      payload = build_payload record
      connection = create_connection
      result = connection.post @form.url.path , payload 
      return response
    end
    
    def build_payload(record)
      payload = create_default_payload
      payload = add_record_data_to_payload record, payload
      payload = add_file_to_payload record, payload
    end

    def create_default_payload(payload={})
      payload[:CISOHEAD] = ""
      payload[:CISOURL] = "http://"
      payload[:CISOFILE] = 'file'
      payload[:CISOTHUMB] = 'auto'
      payload[:CISODB] = @form.collection_id
      return payload
    end
   
    def add_record_data_to_payload(record, payload={})
      @form.fields.each do |field, input_name|
        payload[input_name.to_sym] = record[field.to_sym]
      end
      return payload
    end

    def add_file_to_payload(record, payload={})
      filepath = File.join(@etds.basepath, record[:file_name])
      mime = MIME::Types.type_for(filepath).first.content_type
      payload[:CISOBROWSE] = Faraday::UploadIO.new filepath, mime
      return payload 
    end

    def create_connection()
      connection = Faraday.new(@form.url) do |f|
        f.request :multipart
        f.request :url_encoded
        f.response :logger
        f.headers['Referer'] = "#{@form.url.scheme}://#{@form.url.host}/#{@form.referer_path}"
        f.headers['Connection'] = 'keep-alive'
        f.basic_auth(@creds[:username],@creds[:password])
        f.use FaradayMiddleware::FollowRedirects
        f.adapter :net_http
      end
    end 
  end
end

