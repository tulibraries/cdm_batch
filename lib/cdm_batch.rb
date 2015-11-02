require "cdm_batch/version"
require "cdm_batch/etd_loader"
require "cdm_batch/form"
require "cdm_batch/form_filler"

module CdmBatch

  def self.header_to_symbol(header)
    header.downcase
      .gsub(" ","_")
      .gsub("-","_")
      .to_sym 
  end


end
