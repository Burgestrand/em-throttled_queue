unless defined?(EventMachine)
  module EventMachine
    class Queue
      # this is an ugly hack, really, and if you find
      # a better solution that:
      # - don’t require me to require eventmachine
      # - don’t require me to keep version in two places
      # - i like (:d)
      # then, I will buy you an ice cream
    end
  end
end

module EventMachine
  class ThrottledQueue < Queue
    # Gem version, following Semantic Versioning since v1.0.2
    # @see http://semver.org/
    VERSION = [1, 1, 2].join('.')
  end
end
