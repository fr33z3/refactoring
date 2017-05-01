require 'spec_helper'

RSpec.describe Merger do
  let(:modifier) { spy('Modifier') }
  let(:combiner) do
    [
      [{ 'Key 1' => 1, 'Key 2' => 2 }, { 'Key 1' => 3, 'Key 2' => 4 }],
      [{ 'Key 1' => 5, 'Key 2' => 6 }, { 'Key 1' => 7, 'Key 2' => 8 }]
    ].to_enum
  end
  let(:subject) { described_class.new([modifier], combiner).to_enum }
  let(:modified) { double('Modified') }

  before do
    allow(modifier).to receive(:modify).and_return modified
  end

  it 'merges data' do
    subject.to_a
    expect(modifier).to have_received(:modify).with(
      'Key 1' => [1, 3],
      'Key 2' => [2, 4]
    )

    expect(modifier).to have_received(:modify).with(
      'Key 1' => [5, 7],
      'Key 2' => [6, 8]
    )
  end

  it 'returns merged and combined values' do
    is_expected.to return_elements modified, modified
  end
end
