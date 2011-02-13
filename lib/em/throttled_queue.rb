# coding: utf-8
require 'eventmachine'
require 'em/throttled_queue/version'

# @see https://github.com/eventmachine/eventmachine
module EventMachine
  # An EM::Queue with a rate-limit applied to it. This is useful if you
  # wish to consume items at a limited pace.
  # 
  # @todo Add a maximum size-limit on amount of items in queue.
  class ThrottledQueue < Queue
    # Create a new rate-limited queue.
    # 
    # The queue is allowed to process `limit` items after every `tick`,
    # meaning that the optional `delay` argument controls how many items
    # are popped off within a given timeframe.
    # 
    # Continuously popping items off a queue with a `limit` of 1 and a
    # `delay` of 0.1 will allow a maximum of 25 items to pop within a
    # 2.5 second period.
    # 
    # However, continuously popping items off a queue with a `limit` of
    # 2 and a `delay` of *1* will allow a maximum of 20 items to pop
    # within a 2.5 second period.
    # 
    # @example
    # 
    #   EM::ThrottledQueue.new(0.5)
    #   # => dequeues 0.5 times every second (1 time every 2 seconds)
    # 
    #   EM::ThrottledQueue.new(10, 0.2)
    #   # => dequeues 10 times every 0.2 seconds
    # 
    # @param [Numeric] limit maximum of dequeues every “tick”
    # @param [Numeric] delay number of seconds between ticks (default: 1)
    def initialize(limit, delay = 1)
      @limit   = limit
      @credits = 0
      @ticker  = EM::add_periodic_timer(delay) do
        @credits += @limit
        scheduled_dequeue
      end
      
      super()
    end
    
    # Pop an item off the queue as soon as conditions allow, passing it
    # to the given block.
    #
    # @note The given block is executed within the reactor thread.
    # @yield [item] callback to execute when item is popped off
    # @yieldparam item an item from the queue
    # @return (see #interact)
    # @see http://rdoc.info/github/eventmachine/eventmachine/master/EventMachine.Callback
    def pop(&block)
      interact { @popq.push(block) }
    end
    
    # Push items onto the queue (from within the reactor thread) asap.
    # 
    # @note This call is thread-safe.
    # @param [item, …] items items to be pushed onto the queue
    # @return (see #interact)
    def push(*items)
      interact { @items.push(*items) }
    end
    
    private
      # Helper method to schedule queue interaction and then _dequeue.
      # 
      # @yield block to call within EM::schedule
      # @return [ThrottledQueue]
      def interact(&block)
        EM::schedule do
          block.call
          # next_tick to avoid locking up caller in a dequeuing loop
          EM::next_tick method(:scheduled_dequeue)
        end
        self
      end
      
      # Dequeue as many items as ossible.
      # 
      # @return [ThrottledQueue]
      def scheduled_dequeue
        until @credits < 1 || @items.empty? || @popq.empty?
          @credits -= 1
          @popq.shift.call @items.shift
        end
        self
      end
  end
end