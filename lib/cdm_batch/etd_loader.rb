require 'csv'

module CdmBatch
  class ETDLoader

    attr_reader :data, :basepath

  	def initialize(filepath, basepath=nil)
      @basepath = basepath || File.dirname(filepath)
  	  @data = parse_etd_data_from(filepath)
  	end

	def parse_etd_data_from(filepath)
	  data = []
	  options  = {:headers => :first_row, :col_sep => "\t", :quote_char => "|"}
  		
	  CSV.read(filepath, options).each do |row|
  	    row_hash = Hash[row.headers.map{ |x| CdmBatch.header_to_symbol(x) if x }.zip(row.fields)]
		data << row_hash
		file_check(File.join(@basepath, row_hash[:"file_name"]))
      end
	  return data
	end
		 
	def file_check(filename)
	  raise IOError, "#{filename} was not found." unless File.exists?(filename)
	end
  end 
end
