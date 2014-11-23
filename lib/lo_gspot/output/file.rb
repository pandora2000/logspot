class LoGspot::Output::File
  def initialize(file_name)
    FileUtils.mkdir_p(File.dirname(file_name))
    @file = File.open(file_name, 'a')
  end

  def puts(data)
    file.puts(data[:message])
    file.flush
  end

  def finalize
    @file.close
  end

  private

  attr_reader :file
end
