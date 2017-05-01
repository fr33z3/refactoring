$:.unshift File.expand_path('lib/', File.dirname(__FILE__))
require_relative 'lib/modifier'
require_relative 'lib/extensions'
require_relative 'lib/csv_file_manager'
require_relative 'lib/merger'
require_relative 'lib/splitted_writer'
require 'date'

MODIFICATION_FACTOR = 1
CANCELATION_FACTOR = 0.4

def latest(name)
  files = Dir[File.expand_path("../test_data/*#{name}*.txt", __FILE__)]

  files.sort_by! do |file|
    last_date = /\d+-\d+-\d+_[[:alpha:]]+\.txt$/.match file
    last_date = last_date.to_s.match /\d+-\d+-\d+/

    date = DateTime.parse(last_date.to_s)
    date
  end

  throw RuntimeError if files.empty?

  files.last
end

file_manager = CSVFileManager.new

files = [latest('project_2012-07-27_2012-10-10_performancedata')]
inputs = files.map do |file|
  file_manager.read_sorted(file, 'Clicks').to_enum
end

output_file = File.expand_path('../result_data/results.txt', __FILE__)
output_writer = SplittedWriter.new(file_manager, output_file)

modifier = Modifier.new(MODIFICATION_FACTOR, CANCELATION_FACTOR)
modifier.modify(inputs, output_writer)

puts "DONE modifying"
