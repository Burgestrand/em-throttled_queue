# EM-Throttled_Queue is a throttled queue (surprise, surprise!)
[ThrottledQueue](http://rdoc.info/github/Burgestrand/em-throttled_queue/master/EventMachine/ThrottledQueue) is just like an [EM::Queue](http://rdoc.info/github/eventmachine/eventmachine/master/EventMachine/Queue), but will pop items off itself at a pace specified by you!

Version v1.0.0 and v1.0.1 has an unintentional flaw (result of coding while tired) and should not be used. v1.0.2 is coming as soon as issue #2 is resolved. They have been yanked from rubygems.

Example
-------

    # Example code that will pop off 2 items in total within a period of
    # one second. The other items are not popped because of throttle.
    EM::run do
      # Create a queue that will pop off maximum of 2 items per second,
      # with a refill-limit of 1 second.
      queue = EM::ThrottledQueue.new(2)
  
      queue.push 1 # you can push one item at a time
      queue.push 2, 3, 4, 5, 6 # or several at once
  
      5.times { queue.pop(&EM::Callback(Object, :puts)) }
  
      EM::add_timer(1) { EM::stop }
    end
   
    # Output:
    # 1
    # 2

What problem does EM-Throttled_Queue solve?
-------------------------------------------
At [radiofy](http://radiofy.se/) we consume a lot of external services. As we are rebuilding our internal structures we will be using EventMachine for the consumption of said services. Some of them have an applied rate-limit that will punish you if you don’t restrain how many queries you execute.

As a result, we need to call our blocks of code within the allowed rate-limit. For example, the [Spotify Metadata API](http://developer.spotify.com/en/metadata-api/overview/) allow a maximum of 10 requests per second, and if exceeded will force you to wait 10 seconds (essentially losing 90 reqs/10 seconds). EM::ThrottledQueue will allow us to easily limit how many calls we make per second to their API.

How do I contribute?
--------------------
Fork, add tests (important!), add your code and send a pull request. If you wish to report an issue, please use the GitHub issue tracker. I can also be contacted by mail (visible on [my GitHub user page](http://github.com/Burgestrand)).

As far as development dependencies goes they are all specified in the Gemfile. Once you have checked out the code, a mere `bundle install` should fetch them all for you! \o/

Why don’t you support 1.8.7?
----------------------------
There currently is no reason for me to do so. If you believe there is, file an issue.