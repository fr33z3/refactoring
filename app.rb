require_relative 'lib/modifier'
require_relative 'lib/extensions'
require_relative 'lib/csv_file_manager'
require 'csv'
require 'date'

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
modification_factor = 1
cancellaction_factor = 0.4
modifier = Modifier.new(modification_factor, cancellaction_factor)
modifier.modify(modified, input)

puts "DONE modifying"