require 'spec_helper'

describe CdmBatch do
  it 'has a version number' do
    expect(CdmBatch::VERSION).not_to be nil
  end

  it 'logs each successful upload to current batch log'
  it 'logs errors to current batch error log'
  
  it 'archives current batch log when all items successfully uploaded'
  it 'archives current batch errors log when all items successfully uploaded'

  it 'does not archive current batch log if any batch item raises an error'

  it 'does not re-upload items in cuurent batch log if batch restarted'  
end
