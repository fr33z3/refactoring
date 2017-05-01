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
    puts last_date.to_s.inspect

    date = DateTime.parse(last_date.to_s)
    date
  end

  throw RuntimeError if files.empty?

  files.last
end

modified = input = latest('project_2012-07-27_2012-10-10_performancedata')
modifier = Modifier.new(MODIFICATION_FACTOR, CANCELATION_FACTOR, 'Clicks')
modifier.modify(modified, input)

puts "DONE modifying"
