require 'spec_helper'

describe CdmBatch::FormFiller do
  before(:all) do
    metadata_path = "fixtures/etd-data/etd_tab.txt"
    form_config = "fixtures/forms/test_form.yml"
    @filler = CdmBatch::FormFiller.new metadata_path, form_config   
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

    it '' do
    end
  end
  
end
