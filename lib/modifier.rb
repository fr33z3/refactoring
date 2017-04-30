require 'pry'
require 'csv'
require_relative './combiner'
require_relative './csv_file_manager'
require_relative './modifiers'

class Modifier
  KEYWORD_UNIQUE_ID = 'Keyword Unique ID'
  LAST_VALUE_WIN_KEYS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
  LAST_REAL_VALUE_WIN_KEYS = ['Last Avg CPC', 'Last Avg Pos']
  INT_VALUE_KEYS = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
  FLOAT_VALUE_KEYS = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
  CANCELATION_KEYS = ['number of commissions']
  CANCELATION_SALE_KEYS = ['Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value', 'KEYWORD - Commission Value']

  LINES_PER_FILE = 120000

  def initialize(saleamount_factor, cancellation_factor, file_manager = CSVFileManager.new)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
    @file_manager = file_manager
  end

  def modify(output, input)
    input_enumerator = file_manager.lazy_read(input)

    merger = get_merger(combiner(input))
    done = false
    file_index = 0
    file_name = output.gsub('.txt', '')
    headers = merger.peek.keys
    while not done do
      file_manager.write(file_name + "_#{file_index}.txt", headers) do |csv|
        line_count = 0
        while line_count < LINES_PER_FILE
          begin
            csv << merger.next.values
            line_count += 1
          rescue StopIteration
            done = true
            break
          end
        end
        file_index += 1
      end
    end
  end

  private

  attr_reader :file_manager, :cancellation_factor, :saleamount_factor

  def combiner(input)
    input = sort(input)
    input_enumerator = file_manager.lazy_read(input)

    Combiner.new do |value|
      value[KEYWORD_UNIQUE_ID]
    end.combine(input_enumerator)
  end

  def get_merger(combiner)
    Enumerator.new do |yielder|
      while true
        begin
          merged = combine_hashes(combiner.next)
          yielder.yield(combine_values(merged))
        rescue StopIteration
          break
        end
      end
    end
  end

  def combine_values(hash)
    modifiers.inject(hash) do |res, modifier|
      modifier.modify(res)
    end
  end

  def combine_hashes(list_of_rows)
    list_of_rows.each_with_object({}) do |row, res|
      unless row.nil?
        row.each do |key, value|
          (res[key] ||= []) << value
        end
      end
    end
  end

  public

  def modifiers
    [
      Modifiers::LastValueWins.new(LAST_VALUE_WIN_KEYS),
      Modifiers::LastValueWins.new(LAST_REAL_VALUE_WIN_KEYS),
      Modifiers::IntValues.new(INT_VALUE_KEYS),
      Modifiers::FloatValues.new(FLOAT_VALUE_KEYS),
      Modifiers::Factor.new(cancellation_factor, CANCELATION_KEYS),
      Modifiers::Factor.new(cancellation_factor * saleamount_factor, CANCELATION_SALE_KEYS)
    ]
  end

  def sort(file)
    output = "#{file}.sorted"
    content_as_table = file_manager.read(file)
    headers = content_as_table.headers
    index_of_key = headers.index('Clicks')
    content = content_as_table.sort_by { |a| -a[index_of_key].to_i }
    file_manager.write(output, headers, content)
    return output
  end
end
