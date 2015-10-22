require 'csv'

module CdmBatch
  class ETDLoader

    attr_reader :data

  	def initialize(filepath)
  		@data = []
  		options  = {:headers => :first_row, :col_sep => "\t", :quote_char => "|"}
  		CSV.read(filepath, options).each do |row|
  			data << Hash[row.headers.map{ |x| x.downcase.to_sym if x }.zip(row.fields)]
  		end
  	end
  end 
end