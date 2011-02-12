require 'em/throttled_queue'
require 'minitest/autorun'
require 'minitest/spec'

class << MiniTest::Spec
  def it_enhanced(*args, &block)
    it_original(*args) do
      EM::run_block(&block)
    end
  end
  
  alias_method :it_original, :it
  alias_method :it, :it_enhanced
end

describe EM::ThrottledQueue do
  it "should work properly" do
    EM::reactor_running?.must_equal true
  end
end