require 'spec_helper'


describe CdmBatch::FailedETDWriter do
  before (:all) do 
  	@failed = CdmBatch::FailedETDWriter.new 
  end

  describe '#add_to_failed_upload_tsv' do
    it 'can be called as an instance method' do
      expect(@failed.respond_to?("add_to_failed_upload_tsv")).to be true
    end
  end
end