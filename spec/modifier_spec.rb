require 'spec_helper'

RSpec.describe Modifier do
  let(:modification_factor) { 1 }
  let(:cancelation_factor) { 0.4 }
  let(:modifier) { described_class.new(modification_factor, cancelation_factor) }

  let(:inputs) { [spy('Input enumerator 1'), spy('Input enumerator 2')] }
  let(:output_writer) { spy('Output Writer') }

  let(:combiner) { spy('Combiner') }
  let(:merger) { spy('Merger') }

  let(:rows) { [spy('Row1'), spy('Row2')] }

  describe '#modify' do
    subject { modifier.modify(inputs, output_writer) }

    before do
      allow(Combiner).to receive(:new).with(*inputs).and_return combiner
      allow(Merger).to receive(:new).and_return merger
      allow(merger).to receive(:each).and_yield(rows[0]).and_yield(rows[1])
    end

    it 'creates combiner with inputs' do
      expect(Combiner).to receive(:new).with(*inputs).and_return combiner
      subject
    end

    it 'creates merger with modifiers and combiner' do
      expect(Merger).to receive(:new).with(instance_of(Array), combiner).and_return combiner
      subject
    end

    it 'write rows' do
      subject

      expect(output_writer).to have_received(:write).with(rows[0])
      expect(output_writer).to have_received(:write).with(rows[1])
    end
  end
end
