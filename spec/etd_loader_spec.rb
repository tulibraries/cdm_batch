require 'spec_helper'


describe CdmBatch::ETDLoader do
	
	it 'parses ETD tab delimited file into rows'

	it 'has an attribute data which is a hash ' do
		loader = CdmBatch::ETDLoader.new({})
		expect(loader.data).to be_a Hash
	end

	it ''

	it 'checks that that file related to each metadata entry is present'
	it 'checks that the file is a valid PDF'

end