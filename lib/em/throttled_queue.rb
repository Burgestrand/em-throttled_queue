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
    # @example
    # 
    #   EM::ThrottledQueue.new(10)
    #   # => allows maximum 10 deqs every second
    #
    #   EM::ThrottledQueue.new(5, 10)
    #   # => allows maximum 5 deqs every 10 seconds
    # 
    # @param [Fixnum] maximum of dequeues every +refresh_interval+
    # @param [Fixnum] how many seconds between each refresh of tokens. Default: 1 (second)
    def initialize(limit, refresh_interval = 1)
      @credits = @limit = limit.to_i
      @ticker  = EM::add_periodic_timer(refresh_interval) do
        @credits = @limit
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