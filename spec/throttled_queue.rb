require 'em/throttled_queue'
require 'minitest/autorun'
require 'minitest/spec'

class << MiniTest::Spec
  def it_enhanced(*args, &block)
    it_original(*args) do
      EM::run(&block)
    end unless block.nil?
  end
  
  alias_method :it_original, :it
  alias_method :it, :it_enhanced
end

describe EM::ThrottledQueue do
  it "should pop items in FIFO order" do
    queue = EM::ThrottledQueue.new(1)
    pushed_items = [1, 2, 3, 4]
    popped_items = []
    queue.push(*pushed_items)
    
    1.upto(4) do |i|
      queue.pop do |j|
        popped_items << j
        
        if i == 4
          popped_items.must_equal pushed_items
          EM::stop
        end
      end
    end
  end
  
  it "should pop items within the rate limit" do
    ticks = 0
    deqs  = 0
    
    queue = EM::ThrottledQueue.new(10) # 10 deqs/s
    queue.push(*(1..1000).to_a)
    queue.size.must_equal 1000
    
    EM::add_timer(0.5) do
      deqs.must_equal 10
      (ticks > 100).must_equal true # need good margin
      EM::stop
    end
    
    ticker = proc do |me|
      ticks += 1
      queue.pop { deqs += 1 }
      EM::next_tick { me.call(me) }
    end
    
    ticker.call(ticker)
  end
  
  it "should not build up credits over time" do
    deqs = 0
    
    queue = EM::ThrottledQueue.new(10) # 10 deqs/s
    queue.push(*(1..1000).to_a)
    
    EM::add_timer(3) do
      # Oh this is bad… test tied to implementation details!
      queue.instance_variable_get("@credits").must_equal 10
      EM::stop
    end
  end
  
  it "should load the version" do
    defined?(EM::ThrottledQueue::VERSION).wont_be_nil
    EM::stop
  end
end