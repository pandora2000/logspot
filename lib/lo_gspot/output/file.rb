class LoGspot::Output::File
  def initialize(arg)
    if arg.is_a?(String)
      @physical = true
      FileUtils.mkdir_p(File.dirname(arg))
      @file = File.open(arg, 'a')
    else
      @physical = false
      @file = arg
    end
  end

  def puts(data)
    file.puts(data[:message])
    file.flush
  end

  def finalize
    file.close if physical
  end

  private

  attr_reader :file, :physical
end
