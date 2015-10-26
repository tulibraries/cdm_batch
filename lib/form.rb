require 'uri'
require 'yaml'

module CdmBatch
  class Form

    attr_reader :url, :required_fields, :fields

  	def initialize(url, config_file_path)
	  @url = URI(url)
	  
	  form_config = YAML.load_file(config_file_path)
	  @fields = form_config['form_fields'] 
	  @required_fields = form_config['required_fields']
  	end
  end
end