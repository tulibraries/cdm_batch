require 'spec_helper'

describe CdmBatch::Form do
    
    before(:all) do
      config_file = "fixtures/forms/test_form.yml" 
      @form = CdmBatch::Form.new(config_file)
    end

	it 'accepts a valid http url as the forms URI' do
    expect(@form.url).to be_an_instance_of(URI::HTTP)
	end

	it 'does not accept an invalid http URL as the forms uri' do
	  url  = "not a valid http uri"
		expect{CdmBatch::Form.new("fixtures/forms/test_form.yml", url)}.to raise_error(URI::InvalidURIError)
	end

	  
	it 'defines required fields passed from config' do
      expect(@form.required_fields).to be_an Array
	end

	it 'can handle having no required fields' do
	  form =  CdmBatch::Form.new("fixtures/forms/no_required_form.yml")
	  expect(form.required_fields).to be nil
	end

	it 'defines form fields passed from config' do
	  expect(@form.fields["file"]).to eq("file_input")
	  expect(@form.fields["author"]).to eq("creator")
	  expect(@form.fields["subject"]).to eq("subject")
	end	


end
