require "cdm_batch/version"

module CdmBatch

  def self.header_to_symbol(header)
    header.downcase
      .gsub(" ","_")
      .gsub("-","_")
      .to_sym 
  end


end
