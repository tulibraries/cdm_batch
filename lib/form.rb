require 'uri'

module CdmBatch
  class Form

    attr_reader :url

  	def initialize(url, args={})
	  @url = URI(url)
  	end
  	
  	
  end
end
