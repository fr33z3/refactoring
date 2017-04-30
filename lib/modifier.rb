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

  def initialize(saleamount_factor, cancellation_factor, sort_key, file_manager = CSVFileManager.new)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
    @file_manager = file_manager
    @sort_key = sort_key
  end

  def modify(output, input)
    @input = input

    merger = Merger.new(modifiers, combiner).to_enum(:each)

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

  attr_reader :file_manager, :cancellation_factor, :saleamount_factor, :sort_key

  def input_enum
    file_manager.read_sorted(@input, sort_key).each
  end

  def combiner
    Combiner.new do |value|
      value[KEYWORD_UNIQUE_ID]
    end.combine(input_enum)
  end

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
end
