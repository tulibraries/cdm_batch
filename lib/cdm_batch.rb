require "cdm_batch/version"

module CdmBatch


	def self.header_to_symbol(header)
		header.downcase.sub(" ","_").to_sym 
	end

  def initialize(metadata_path, form_path, map_path, credentials)
	
  end

end
