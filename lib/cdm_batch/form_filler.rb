require 'faraday'
require 'faraday_middleware'
require 'mime-types'
require 'csv'

module CdmBatch
  class FormFiller
    attr_reader :etds, :form

    def initialize(metadata_path, form_config_path, credentials={})
      @etds = ETDLoader.new(metadata_path)
      @form = Form.new(form_config_path, form_url=nil)
      @creds = credentials
      @could_not_be_uploaded
    end

    def upload_batch
      result = {:failed =>  [], :succeeded => []}
      @etds.data.each_with_index do |record, index|
        response = upload_single_record record
        if response.body.include?("<META HTTP-EQUIV=\"refresh\"") 
          result[:succeeded] << {:index => index, :file_name => record[:file_name]} 
        elsif response.body.include?("The item was not added to the pending queue.")
          #log size failure - Add csv data to file? 
          result[:failed] << index
        else
          #log 
        end
      end
      return result
    end

    def upload_single_record(record)
      payload = build_payload record
      connection = create_connection
      response = connection.post @form.url.path , payload 
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

    def could_not_upload(record)
      @could_not_be_uploaded ||= create_could_not_be_uploaded_tsv

 
    end  

    def create_could_not_be_uploaded_tsv()
      filepath = FILE.join @etds.basepath, "could_not_be_uploaded.tsv"
      options  = {:col_sep => "\t"}
      not_uploaded_log = CSV.open(filepath, "wb", options) do |csvfile|
        csvfile << @etds.data.first.headers
      end
      return csvfile

    end
  end
end

