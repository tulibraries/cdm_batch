require 'spec_helper'

describe CdmBatch::FormFiller do
  before(:all) do
    metadata_path = "fixtures/etd-data/etd_tab.txt"
    form_config = "fixtures/forms/test_form.yml"
    @filler = CdmBatch::FormFiller.new metadata_path, form_config   
  end

  describe '#new' do

    it 'exposes data from parsed files' do
      expect(@filler.respond_to?('etds')).to be true
    end

    it 'exposes the form that will be filled' do
      expect(@filler.respond_to?('form')).to be true
    end

    it 'does not expose credentials' do
      expect(@filler.respond_to?('creds')).to be false
    end

  end
  
  describe '#create_default_payload' do
  	let(:payload) { @filler.create_default_payload}
  	
  	it 'returns a Hash' do
      expect(payload).to be_a Hash 
    end

    it 'returns the CISODB value correctly' do
      expect(payload[:CISODB]).to eq("/TESTING-ID") 
    end
  end
  
  describe '#add_record_data_to_payload' do
  	let(:record) {@filler.etds.data[0]}
    let(:payload) { @filler.add_record_data_to_payload record}

    it 'returns a Hash' do
      expect(payload).to be_a Hash
    end

    it 'populates form fields with expected data' do
      expect(payload[:title]).to eq("Influences of Testing on Code Quality")
    end

    it 'leaves existing payload data intact' do
      existing_payload = {:test => "value"}
      payload = @filler.add_record_data_to_payload(record, existing_payload)
      expect(payload[:test]).to eq("value")
    end
  end

  describe '#add_file_to_payload' do
    existing_payload = {:test => "value"}
    let(:payload) { @filler.add_file_to_payload @filler.etds.data[0] }

    it 'returns a hash' do
      expect(payload).to be_a Hash
    end

    it 'populates the CISOBROWSE field with an UploadIO object' do
      expect(payload[:CISOBROWSE]).to be_an_instance_of UploadIO
    end

    it 'leaves existing payload data intact' do
      existing_payload = {:test => "value"}
      payload = @filler.add_file_to_payload @filler.etds.data[0], existing_payload
      expect(payload[:test]).to eq("value")
    end

    it 'dynamically sets content type' do
      expect(payload[:CISOBROWSE].content_type).to eq("application/pdf")
    end
  end

  describe '#create_connection' do
    let(:connection) { @filler.create_connection }
    
    it 'builds Referer header correctly' do
      expect(connection.headers['Referer']).to eq("https://our.example.tld/cgi-bin/admin/add.exe?CISODB=/TESTING-IDcoll11&CISOHEAD=&CISOMODE=1")
    end

    it 'defines a basic authorization header' do
      expect(connection.headers['Authorization']).to include("Basic")
    end

    it 'lists net::http as last in handlers list' do
      expect(connection.builder.handlers.last).to eq(Faraday::Adapter::NetHttp)
    end

    it 'contains both url_encode and multipart in handlers' do
      expect(connection.builder.handlers).to include(Faraday::Request::Multipart, Faraday::Request::UrlEncoded)
    end
  end

  describe '#upload_batch'do
  RSpec.configure do |config|
    config.before(:context) do
    # Stub the dummy url in fixtures/forms/test_form.yml to return
    # a failed request  
      stub_request(:post, "https://our.example.tld/dmscripts/admin/dmadd.php").
        to_return(:body => "The item was not added to the pending queue. If you tried to add a very large file, use the Project Client to add the file.")
    end
  end
    let(:result) { @filler.upload_batch}

    it 'returns a hash ' do 
      expect(result).to have_key(:failed)
      expect(result).to have_key(:succeeded)
    end

    it 'includes an array of all failed records' do
      expect(result[:failed].length).to eq(2)
    end

  end
end
