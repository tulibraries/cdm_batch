require 'spec_helper'

describe CdmBatch::Form do
	it 'accepts a valid http url as the forms URI' do
	  url = "http://www.examplecdm.com/path/to/form"
	 	form = CdmBatch::Form.new(url)
    expect(form.url).to be_an_instance_of(URI::HTTP)
	end

	it 'does not accept an invalid http URL as the forms uri' do
	  url  = "not a valid http uri"
		expect{CdmBatch::Form.new(url)}.to raise_error(URI::InvalidURIError)
	end

	  

	it 'defines required fields'
end
