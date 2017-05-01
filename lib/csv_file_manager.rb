require 'csv'
require_relative './extensions'

class CSVFileManager
  DEFAULT_CSV_OPTIONS = {
    :col_sep => "\t",
    :headers => :first_row,
    :row_sep => "\r\n"
  }

  def initialize(options = nil)
    @options = options || DEFAULT_CSV_OPTIONS
  end

  def read(file_path)
    CSV.read(file_path, options)
  end

  def read_sorted(file_path, sort_key)
    content = read(file_path)
    sort_index = content.headers.index(sort_key)
    content.sort_by {|row| -row[sort_index].to_i }
  end

  def lazy_read(file_path)
    Enumerator.new do |yielder|
      CSV.foreach(file_path, options) do |row|
        yielder.yield(row)
      end
    end
  end

  def open_write(file_path)
    CSV.open(file_path, 'wb', options)
  end

  private

  def csv_read_options
  end

  attr_reader :file_path, :options
end
