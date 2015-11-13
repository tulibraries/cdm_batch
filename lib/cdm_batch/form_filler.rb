require 'faraday'
require 'faraday_middleware'
require 'mime-types'
require 'cdm_batch/logger'

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
      @etds.data.each_with_index do |record, index|
        response = upload_single_record record
        log_response response, record, index
      end
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

    def log_response(response, record, index)
      if response.body.include?("<META HTTP-EQUIV=\"refresh\"") 
        SuccessLogger.write_log ("File '#{record[:file_name]}' with title '#{record[:title]}' successfully uploaded") 
      else 
        if response.body.include?("The item was not added to the pending queue.")
          message = "File '#{record[:file_name]}' with title '#{record[:title]}' was not uploaded because it was too big. Please use the project client"
        else
          message = "File '#{record[:file_name]}' with title '#{record[:title]}'  was not uploaded becuase of on unexpected response from the server."
        end
        FailureLogger.write_log(message)
        CdmBatch::FailedETDWriter.new.add_to_failed_upload_tsv @etds.filepath, index
      end
    end
  end
end

