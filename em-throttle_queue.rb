require 'eventmachine'

module EventMachine
  # An EM::Queue with a rate-limit applied to it. This is useful if you
  # wish to consume items at a limited pace.
  # 
  # @todo Add a maximum size-limit on amount of items in queue.
  # @todo Allow specifying how many ticks per second.
  class ThrottledQueue < Queue
    # Public: Create a new rate-limited queue.
    # 
    # limit - Numeric maximum of dequeues every tick
    # delay - Numeric delay in seconds between ticks (default: 1)
    # 
    # Examples
    # 
    #   EM::ThrottledQueue.new(0.5)
    #   # => dequeues 0.5 times every second (1 time every 2 seconds)
    # 
    #   EM::ThrottledQueue.new(10, 0.2)
    #   # => dequeues 10 times every 0.2 seconds
    # 
    # Returns nothing.
    def initialize(limit = 0, delay = 1)
      @limit   = limit
      @credits = 0
      @ticker  = EM::add_periodic_timer(delay) do
        @credits += @limit
        scheduled_dequeue
      end
      
      super()
    end
    
    # Public: Pop an item off the queue as soon as conditions allow. The
    # given block is executed in the reactor thread.
    #
    # Returns self.
    def pop(*a, &b)
      cb = EM::Callback(*a, &b)
      interact { @popq.push(cb) }
    end
    
    # Public: Push items onto the queue on the next reactor tick.
    # 
    # *items - any number of items to be pushed onto the queue.
    # 
    # Returns self.
    def push(*items)
      interact { @items.push(*items) }
    end
    
    private
      # Helper method to schedule queue interaction and then _dequeue.
      #
      # Returns self.
      def interact(&block)
        EM::schedule do
          block.call
          # next_tick to avoid locking up caller in a dequeuing loop
          EM::next_tick method(:scheduled_dequeue)
        end
      end
      
      # Dequeue as many items as ossible.
      # 
      # Returns nothing.
      def scheduled_dequeue
        until @credits < 1 || @items.empty? || @popq.empty?
          @credits -= 1
          @popq.shift.call @items.shift
        end
      end
  end
end

if $0 == __FILE__ then
  
  ticks = 0
  deqs  = 0
  n     = 0
  
  puts "Running EM for 5 seconds..."
  EM::run do
    EM::add_timer(5) { EM::stop } # run maximum 5 seconds (50 jobs)
    queue = EM::ThrottledQueue.new(1, 0.1)
    queue.push(*(0..1000).to_a)
    
    ticker = proc do |me|
      ticks += 1
      queue.pop { |i| deqs += 1 and n += i }
      EM::next_tick { me.call(me) }
    end
    
    ticker.call(ticker)
  end
  
  # TODO:
  # - test for #pop order (FIFO)
  # - test for #pop rate limit
  # - test for #pop arguments 
  # - report EM::schedule possible lock-up bug (see #interact)
  
  puts "N: #{n}"
  print "With #{ticks} pops (ticks), I dequeued #{deqs} times in 5 seconds: "
  
  if (40..50).include?(deqs) and ticks > 100
    puts "this is OK!"
  else
    abort "this is a bug!"
  end
end  