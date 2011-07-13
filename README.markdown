# Throttled Queue is a throttled queue
[ThrottledQueue](http://rdoc.info/github/Burgestrand/em-throttled_queue/master/EventMachine/ThrottledQueue) is just like an [EM::Queue](http://rdoc.info/github/eventmachine/eventmachine/master/EventMachine/Queue), but will pop items off itself at a pace specified by you.

**NOTE**: Version v1.0.0 and v1.0.1 has an unintentional flaw, and should not be used.

**NOTE**: I personally won’t be doing any development on this library, but I will accept
pull requests. If you want take over maintenance of this library for further development,
please do contact me.

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

Installation
------------

> gem install [em-throttled_queue](https://rubygems.org/gems/em-throttled_queue)

How do I contribute?
--------------------
[Fork](http://help.github.com/forking/), write tests, add your code and send a pull request. If you modify existing files, please adhere to the coding standard surrounding your code. If you wish to report an issue, please use the GitHub issue tracker. I can also be contacted by mail (visible on [my GitHub user page](http://github.com/Burgestrand)).

Development dependencies are specified in the gem specification, and can be installed using rubygems.

    gem install em-throttled_queue --development

There’s also a Gemfile in the repository, allowing you to install dependencies via bundler.

    bundle install

Why don’t you support 1.8.7?
----------------------------
There currently is no reason for me to do so. If you believe there is, file an issue.