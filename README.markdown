# THIS LIBRARY HAS BEEN ABANDONED!

If somebody wants to take on the project and make something useful of it, go on ahead. I, personally, will not be doing *any* more work on this.

---

# EM-Throttled_Queue is a throttled queue (surprise, surprise!)
[ThrottledQueue](http://rdoc.info/github/Burgestrand/em-throttled_queue/master/EventMachine/ThrottledQueue) is just like an [EM::Queue](http://rdoc.info/github/eventmachine/eventmachine/master/EventMachine/Queue), but will pop items off itself at a pace specified by you!

*NOTE*: Version v1.0.0 and v1.0.1 has an unintentional flaw (result of coding while tired) and should not be used.

Usage
-----
    require 'em/throttled_queue'
    
    # Example code that will pop off 2 items in total within a period of
    # one second. The other items are not popped because of throttle.
    EM::run do
      # Create a queue that will pop off maximum of 2 items per second.
      queue = EM::ThrottledQueue.new(2)
  
      queue.push 1 # you can push one item at a time
      queue.push 2, 3, 4, 5, 6 # or several at once
  
      5.times { queue.pop(&EM::Callback(Object, :puts)) }
  
      EM::add_timer(1) { EM::stop }
    end
   
    # Output:
    # 1
    # 2

Gem is on rubygems.org, so installation is a mere `gem install em-throttled_queue`.

How do I contribute?
--------------------
Fork, add tests (important!), add your code and send a pull request. If you wish to report an issue, please use the GitHub issue tracker. I can also be contacted by mail (visible on [my GitHub user page](http://github.com/Burgestrand)).

As far as development dependencies goes they are all specified in the Gemfile. Once you have checked out the code, a mere `bundle install` should fetch them all for you! \o/

Why don’t you support 1.8.7?
----------------------------
There currently is no reason for me to do so. If you believe there is, file an issue.