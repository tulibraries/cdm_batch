require "etd_loader"
require "form"
require 'net/http/post/multipart'

module CdmBatch
  class FormFiller
    def initialize(metadata_path, form_config_path, credentials)
      @etds = CdmBatch::ETDLoader.new(metadata_path)
      @form = CdmBatch::Form.new(form_config_path, form_url=nil)
      @credentials = credentials
    end

    def submit_single_record(record)
	form_values = {}
        @form.fields.each do |field, input_name|
	  if record[field.to_sym]
	    form_values << input_name => record[field.to_sym]  
	  end
        end	  
	
	File.open(File.join(form.basepath, record[:file_name])) do |pdf|
	  req = Net::HTTP::Post::Multipart.new form.url.path, form_values,
	    @form.fields[:file] => UploadIO.new(pdf, "application/pdf", @form.fields[:file_name])
	  res = Net::HTTP.start(form.url.host, form.url.port) do |http|
            http.request(req)		
	  end 
        end	  
      end
    end
  end
end

