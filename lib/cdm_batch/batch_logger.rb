require 'cdm_batch'
require 'logger'

module CdmBatch
  class BatchLogger

    attr_accessor :logger

    def initialize(logtype)
      logname  = pick_logname logtype
      filepath = File.join(Dir.pwd, "#{logname}") 
      @logger = Logger.new(filepath)
    end

    def  pick_logname(logtype)
      if logtype.eq("failure")
        logname = "cdm-batch-error.log"
      else
        logname = "cdm-batch.log"
      end
      retun logname 
    end

    def log_successful_upload(record)
      
    end 

    def self.could_not_upload()
      @could_not_be_uploaded ||= create_could_not_be_uploaded_tsv
    end  

    def self.create_could_not_be_uploaded_tsv()
      filepath = FILE.join @etds.basepath, "could_not_be_uploaded.tsv"
      options  = {:col_sep => "\t"}
      not_uploaded_log = CSV.open(filepath, "wb", options) do |csvfile|
        csvfile << @etds.data.first.headers
      end
      return csvfile
    end
  end
end
