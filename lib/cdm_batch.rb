require "cdm_batch/version"
require "cdm_batch/etd_loader"
require "cdm_batch/form"
require "cdm_batch/form_filler"
require "cdm_batch/logger"
require "cdm_batch/failed_etd_writer"
require "yaml"

module CdmBatch


  def self.header_to_symbol(header)
    header.downcase
      .gsub(" ","_")
      .gsub("-","_")
      .to_sym 
  end

  def self.get_cdm_credentials
  	
  	creds = get_creds_from_yaml
  	unless creds
      puts "ContentDM username"  
      STDOUT.flush  
      username = STDIN.gets.chomp
      
      puts "Password"  
      STDOUT.flush  
      password = STDIN.gets.chomp

      creds = {:username => username, :password => password}
    end
    creds
  end

  def self.get_creds_from_yaml(filename=nil)
  	filename ||= ".cdm_creds"
  	if File.exists?(filename)
      yaml_creds = File.open(filename) { |file| YAML.load(file) }
      creds = {:username => yaml_creds["username"], :password => yaml_creds["password"]}
    else
      creds =  nil  
  	end
    return creds
  end




end
