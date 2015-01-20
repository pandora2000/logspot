require_relative 'initialize'

class LoGspot
  LOG_LEVELS = %w(DEBUG INFO WARN ERROR FATAL)

  def initialize(file_or_file_name = STDOUT, wrapper: nil, tag_format: '[%{time} %{level}] ', time_format: '%Y/%m/%d %H:%M:%S', tag_block: nil)
    wrapper = ->(output, data) {
      base = tag_block ? tag_block.(Time.current, level) : tag_format % { time: Time.current.strftime(time_format), level: level }
      if data[:space]
        base = ' ' * base.length
      end
      output.puts(message: "#{base}#{data[:message]}")
    }
    @raw_output = @file = Output::File.new(file_or_file_name)
    @top_output = @output = Output::Wrap.new(wrapper, @file)
    @level = nil
  end

  def tagged(tag, &block)
    wrap_output(block) do |output, data|
      base = tag
      if space = !!data[:space]
        base = ' ' * base.length
      end
      output.puts(data.merge(message: "#{base}#{data[:message]}", space: space))
    end
  end

  def tagged_list(tag, *args, &block)
    first = true
    wrap_output(block, *args) do |output, data|
      message = data[:message]
      base = tag
      if data[:space] || !first
        base = ' ' * base.length
      end
      if first
        output.puts(data.merge(message: "#{base}#{message}", space: false))
        first = false
      else
        output.puts(data.merge(message: "#{base}#{message}", space: true))
      end
    end
  end

  def hash(h, &block)
    len = (h.keys.map(&:length).max || 0) + 2
    h.each do |key, value|
      tagged_list("#{key}: ".ljust(len), key, value, &block)
    end
  end

  def value(level, v, options = {})
    if v.is_a?(Hash)
      hash(v) do |k, v|
        value(level, v, options)
      end
    elsif v.is_a?(Array)
      h = Hash[v.map.with_index do |v, i|
                 [i.to_s, v]
               end]
      value(level, h, options)
    else
      if p = options[:split_proc]
        p.call(v.to_s).each do |line|
          send(level, line)
        end
      elsif max = options[:max_columns]
        v.to_s.split('').each_slice(max).map { |x| x.join('') }.each do |line|
          send(level, line)
        end
      else
        send(level, v)
      end
    end
  end

  def untagged(&block)
    previous_output, @output = output, output.inner_output
    block.call
    @output = previous_output
  end

  def top(&block)
    previous_output, @output = output, top_output
    block.call
    @output = previous_output
  end

  def raw(&block)
    previous_output, @output = output, raw_output
    block.call
    @output = previous_output
  end

  LOG_LEVELS.each do |level|
    define_method(level.downcase) do |*args, &block|
      write(level, *args, &block)
    end
  end

  def finalize
    @file.finalize
  end

  private

  attr_reader :raw_output, :top_output, :output, :level

  def write(l, *args, &block)
    @level = l
    output.puts(message: args[0], args: args, arg_block: block)
  end

  def wrap_output(block, *args, &wrapper)
    previous_output, @output = output, Output::Wrap.new(wrapper, output)
    res = block.call(*args)
    @output = previous_output
    res
  end
end
