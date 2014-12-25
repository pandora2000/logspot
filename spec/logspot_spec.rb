require 'spec_helper'

describe LoGspot do
  let(:filename) { File.expand_path('../../tmp/spec.log', __FILE__) }
  let(:logger) { LoGspot.new(filename) }
  let(:read) { -> { File.read(filename) } }

  describe '#write' do
    it 'should output' do
      logger.info('test')
      expect(read.call).to include 'test'
    end
  end

  describe '#value' do
    it 'should output' do
      logger.value(:info, test: 'test')
      expect(read.call).to include 'test: test'
    end
  end
end
