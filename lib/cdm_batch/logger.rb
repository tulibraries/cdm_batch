require 'cdm_batch'
require 'logger'

module CdmBatch
  module BatchLogger 
    
    def self.get_log_filepath(log_filename, log_directory=nil)
      log_directory ||= Dir.pwd
      return File.join(log_directory, log_filename) 
    end

    def self.write_to_log(log_path, log_level, message)
      logger = Logger.new(log_path)
      logger.add(log_level) { message }
      logger.close
    end
  end

  class SuccessLogger
    include BatchLogger

    def self.write_log(message)      
      log_filename = "batch_upload.log"
      log_path = BatchLogger.get_log_filepath log_filename 
      log_level = Logger::INFO
      BatchLogger.write_to_log(log_path, log_level, message) 
    end
  
    def self.already_uploaded?(record_filename, log_filepath=nil)
      log_filepath ||= "batch_upload.log"
      if File.exists?(log_filepath)
        uploaded = File.open(log_filepath) do |f|
          f.each_line.detect do |line|
            /#{record_filename}/.match(line)
          end
        end
      else
        uploaded = false
      end
      if uploaded 
        return true 
      else 
        return false
      end
    end
  end

  class FailureLogger
    include BatchLogger
    
    attr_accessor :log_path
    
    def self.write_log(message)
      log_filename = "batch_upload-failed.log"
      log_path = BatchLogger.get_log_filepath log_filename
      log_level = Logger::DEBUG
      BatchLogger.write_to_log(log_path, log_level, message)
    end

    
    
  end
end
