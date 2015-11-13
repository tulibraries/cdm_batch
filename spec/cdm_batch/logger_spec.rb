require 'spec_helper'

describe CdmBatch::SuccessLogger do
  before(:all) do
    @success = CdmBatch::SuccessLogger.new
  end


  describe '#already_uploaded?' do
    before(:all) do
      logfile = File.join("fixtures", "log", "batch_upload.log")
      filename = "TETDEDXDatapoint-temple-12345-6789.pdf"
      @uploaded = CdmBatch::SuccessLogger.already_uploaded? filename, logfile
    end
    it 'should find a filename in a log' do
      expect(@uploaded).to be true
    end

  end
end