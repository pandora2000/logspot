require 'spec_helper'

describe LoGspot do
  let(:filename) { File.expand_path('../../tmp/spec.log', __FILE__) }

  before do
    FileUtils.rm(filename) if File.exists?(filename)
  end

  let(:tag_format) { '' }
  let(:logger) { LoGspot.new(filename, tag_format: tag_format) }
  let(:read) { -> { File.read(filename) } }

  describe '#write' do
    it 'should output properly' do
      logger.info('test')
      expect(read.()).to eq "test\n"
    end
  end

  describe '#value' do
    it 'should output properly' do
      logger.value(:info, test: 'test')
      expect(read.()).to eq "test: test\n"
    end
  end

  describe '#tagged' do
    it 'should output properly' do
      logger.tagged('tag') do
        logger.info('test')
      end
      expect(read.()).to eq "tagtest\n"
    end
  end

  describe '#tagged_list' do
    it 'should output correctly indented logs' do
      logger.tagged_list('tag') do
        logger.info('test1')
        logger.info('test2')
      end
      expect(read.()).to eq "tagtest1\n   test2\n"
    end

    context 'with tag format' do
      let(:tag_format) { 'tag_format' }

      it 'should output correctly indented logs' do
        logger.tagged_list('tag') do
          logger.info('test1')
          logger.info('test2')
        end
        expect(read.()).to eq "tag_formattagtest1\n             test2\n"
      end
    end

    context 'with tag block' do
      let(:time) { Time.current }
      let(:tag_block) { ->(t, level) { "#{time.to_s} #{level}" } }
      let(:logger) { LoGspot.new(filename, tag_block: tag_block) }

      it 'should output correctly indented logs' do
        logger.tagged_list('tag') do
          logger.info('test1')
          logger.info('test2')
        end
        expect(read.()).to eq "#{time.to_s} INFOtagtest1\n#{' ' * time.to_s.length}        test2\n"
      end
    end
  end

  describe '#untagged' do
    it 'should output properly' do
      logger.tagged('tag') do
        logger.tagged('tag2') do
          logger.untagged do
            logger.info('test')
          end
        end
      end
      expect(read.()).to eq "tagtest\n"
    end
  end

  describe '#top' do
    let(:tag_format) { 'a' }

    it 'should output properly' do
      logger.tagged('tag') do
        logger.top do
          logger.info('test')
        end
      end
      expect(read.()).to eq "atest\n"
    end
  end

  describe '#raw' do
    let(:tag_format) { 'a' }

    it 'should output properly' do
      logger.tagged('tag') do
        logger.raw('test')
      end
      expect(read.()).to eq "test"
    end
  end
end
