require 'cdm_batch'

module CdmBatch
  class BatchLogger

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
