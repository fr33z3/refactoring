require 'csv'
require_relative './extensions'

class CSVFileManager
  DEFAULT_CSV_OPTIONS = {
    :col_sep => "\t",
    :headers => :first_row,
    :row_sep => "\r\n"
  }

  def initialize(options = {})
    @options = DEFAULT_CSV_OPTIONS.merge(options)
  end

  def read(file_path)
    CSV.read(file_path, options)
  end

  def lazy_read(file_path)
    Enumerator.new do |yielder|
      CSV.foreach(file_path, options) do |row|
        yielder.yield(row)
      end
    end
  end

  def write(file_path, headers, content)
    CSV.open(file_path, "wb", options) do |csv|
      csv << headers
      content.each{|row| csv << row}
    end
  end

  private

  def csv_read_options
  end

  attr_reader :file_path, :options
end
