module CdmBatch
  class FailedETDWriter
    
    def initialize(filename=nil)
      @filename = filename || "could_not_be_uploaded.tsv"
      @write_options  = {:col_sep => "\t"}
      @read_options = {:headers => :first_row, :col_sep => "\t", :quote_char => "|"}
    end

    def add_to_failed_upload_tsv(original_etds_filepath, index )
      unless File.exists?(@filename) 
        create_could_not_be_uploaded_tsv(original_etds_filepath)
      end

      CSV.open(@filename, "ab+", @write_options) do |csvfile|
        csvfile << CSV.read(original_etds_filepath, @read_options)[index]
      end
    end  

    def create_could_not_be_uploaded_tsv(original_etds_filepath) 
      CSV.open(@filename, "ab+", @write_options) do |csvfile|
        csvfile << CSV.read(original_etds_filepath, @read_options).headers
      end
    end
  end
end