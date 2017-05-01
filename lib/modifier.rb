require 'pry'
require 'csv'
require_relative './combiner'
require_relative './csv_file_manager'
require_relative './modifiers'

class Modifier
  KEYWORD_UNIQUE_ID = 'Keyword Unique ID'.freeze
  LAST_VALUE_WIN_KEYS = [
    'Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type',
    'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND',
    'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD'
  ].freeze
  LAST_REAL_VALUE_WIN_KEYS = ['Last Avg CPC', 'Last Avg Pos'].freeze
  INT_VALUE_KEYS = [
    'Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks',
    'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks'
  ].freeze
  FLOAT_VALUE_KEYS = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos'].freeze
  CANCELATION_KEYS = ['number of commissions'].freeze
  CANCELATION_SALE_KEYS = [
    'Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value',
    'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value',
    'ADGROUP - Commission Value', 'KEYWORD - Commission Value'
  ].freeze

  def initialize(saleamount_factor, cancellation_factor)
    @saleamount_factor = saleamount_factor
    @cancellation_factor = cancellation_factor
  end

  def modify(inputs, output_writer)
    combiner = Combiner.new(*inputs) { |value| value[KEYWORD_UNIQUE_ID] }
    merger = Merger.new(modifiers, combiner)

    merger.each do |row|
      output_writer.write(row)
    end
    output_writer.close
  end

  private

  attr_reader :cancellation_factor, :saleamount_factor

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
