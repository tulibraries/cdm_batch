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
payload = {:CISOBROWSE => Faraday::UploadIO.new("fixtures/etd-data/TETDEDXMcTesterson-temple-12345-6789.pdf", "application/pdf")}
payload.merge!(:CISOFILE => 'file')
payload.merge!({:creato => 'Test Author from cli'})
payload.merge!(:title => 'Test from cli')
payload.merge!(:CISOTHUMB => 'auto')
payload.merge!(:CISODB => '/p245801coll11')
payload.merge!(:digita => 'Dissertations Test')
connect = Faraday.new("https://server16002.contentdm.oclc.org") do |f|
  f.request :url_encoded
  f.request :multipart
  f.headers['Referer'] = "https://server16002.contentdm.oclc.org/cgi-bin/admin/add.exe?CISODB=/p245801coll11&CISOHEAD=&CISOMODE=1"
  f.headers['Connection'] = 'keep-alive'
  f.basic_auth(@credentials['username'],@credentials['password'])
  f.adapter :net_http
end	
connect.post "/dmscripts/admin/dmadd.php", payload 
      end
    end
  end
end

