require 'spec_helper'


describe CdmBatch::ETDLoader do
	
	before(:all) do
	  @etds = CdmBatch::ETDLoader.new("fixtures/etd-data/etd_tab.txt")
	end

	describe "how the data should be parsed" do
	  it 'parses ETD file into an aray item per row' do
	    expect(@etds.data.length).to eq(2)
	  end
	  
	  it 'creates a hash for each row' do
	  	@etds.data.each do |row|
	  		expect(row).to be_an_instance_of Hash 
	  	end
	  end

	  describe "how the data for each record is stored" do
	    it 'has author date' do
	      expect(@etds.data[0][:author]).to eq "McTesterson, Test Y"
	      expect(@etds.data[1][:author]).to eq "Datapoint, Ima Mock"
	    end

	    it 'has title data' do
	      expect(@etds.data[0][:title]).to eq "Influences of Testing on Code Quality"
	    end

	    it 'has filename data' do
	      expect(@etds.data[0][:"file_name"]).to eq "TETDEDXMcTesterson-temple-12345-6789.pdf"
	      expect(@etds.data[1][:"file_name"]).to eq "TETDEDXDatapoint-temple-12345-6789.pdf"
	    end
	  end  
	end

	describe 'how the path to the etd data and pdfs is exposed'
	  it 'exposes basepath attr' do
        expect(@etds.basepath).to eq "fixtures/etd-data"
	  end

	describe '#file_check' do
	  it 'throws an error of a file is not present' do
			missing_files = "fixtures/etd-data/etd_missing_files.txt"
		  expect {CdmBatch::ETDLoader.new(missing_files)}.to raise_exception(IOError) 
		end
	end

end
