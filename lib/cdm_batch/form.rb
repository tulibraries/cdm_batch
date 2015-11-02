require 'uri'
require 'yaml'

module CdmBatch
  class Form

    attr_reader :url, :required_fields, :fields, :referer_path, :collection_id

    def initialize(config_file_path, form_url=nil)
      form_config = YAML.load_file(config_file_path)
      @fields = form_config['form_fields'] 
      @required_fields = form_config['required_fields']
      @url = URI(form_url || form_config['url'])
      @collection_id = form_config['collection_id']
      @referer_path = form_config['referer_path'] 
    end
  end
end
