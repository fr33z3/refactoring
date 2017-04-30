require 'spec_helper'

RSpec.describe Modifier do
  let(:modification_factor) { 1 }
  let(:cancelation_factor) { 0.4 }
  let(:modifier) { described_class.new(modification_factor, cancelation_factor) }

  let(:input_file) { File.expand_path("../support/test.txt", __FILE__) }
  let(:output_file) { File.expand_path("../support/result.txt", __FILE__) }

  describe '#modify' do
    subject { modifier.modify(input_file, input_file) }

    it do
      subject
    end
  end
end
