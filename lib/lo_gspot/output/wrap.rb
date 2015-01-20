class LoGspot::Output::Wrap
  def initialize(wrapper, output)
    @wrapper = wrapper
    @output = output
  end

  def puts(data)
    wrapper.call(output, data)
  end

  def inner_output
    output
  end

  private

  attr_reader :wrapper, :output
end
