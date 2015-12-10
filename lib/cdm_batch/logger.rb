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

    def self.string_in_logfile?(string, log_filepath)
      return false unless File.exists?(log_filepath)
      File.open(log_filepath) do |f|
        f.each_line.detect do |line|
          /#{string}/.match(line)
        end
      end
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
      BatchLogger.string_in_logfile? record_filename, log_filepath
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
