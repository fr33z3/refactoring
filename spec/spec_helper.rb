$LOAD_PATH.unshift File.expand_path('../lib/', File.dirname(__FILE__))
Dir[File.expand_path('../../lib/*.rb', __FILE__)].each do |file|
  require file
end
require_relative 'support/matchers'
require 'rspec'

def read_from_enumerator(enumerator)
  result = []
  loop do
    begin
      result << enumerator.next
    rescue StopIteration
      break
    end
  end
  result
end

def enumerator_for(*array)
  array.to_enum :each
end
