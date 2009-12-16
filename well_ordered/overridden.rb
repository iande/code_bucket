module WellOrdered
  # Methods from Enumerable that are either not generally possible (to_a)
  # or meaningless in the presence of the well ordered (sort)
#  module Overridden
    # While a finite collection of well-ordered items may, itself, be out
    # of order, the well-ordered items are always in order.
    def sort
      self
    end

    def sort_by
      self
    end
    
    # By default, return ourself
    #def cycle
    #end


    # In general, we are working with infinite (though countable) sequences.
    # By default, we raise an exception when to_a is invoked.
    def to_a
      raise "can't make an array of an unbounded sequence"
    end
    alias entries to_a

    def count
      raise "unbounded sequences, in general, do not the count you are looking for"
    end

    def all?
      return true unless block_given?
      raise "cannot test unbounded sequence for total satisfaction"
    end

    # This we can kind of fake, but it might still result in a non-terminating
    # loop.
    def any?(&block)
      return true unless block_given?
      if block_given? && self.detect(&block)
        true
      else
        # Chances are, you never get here.
        false
      end
    end

    def one?
      return false unless block_given?
      raise "cannot test unbounded sequence for only one occurrence"
    end

    def none?
      return false unless block_given?
      raise "cannot test unbounded sequence for no matches"
    end

    def min
      raise "unbounded sequences, in general, have no minimum"
    end

    def max
      raise "unbounded sequences, in general, have no maximum"
    end

    def minmax
      raise "unbounded sequences, in general have no min/max"
    end

    def min_by
      raise "unbounded sequences, in general, have no minimum"
    end

    def max_by
      raise "unbounded sequences, in general, have no maximum"
    end

    # I have no idea how to approach inject yet.
    def inject
      raise "not implemented"
    end

    alias fold inject

    def drop(n)
      raise "not implemented"
    end

    def drop_while
      raise "not implemented"
    end

    def grep
      raise "not implemented"
    end

    def group_by
      raise "not implemented"
    end

    def partition
      raise "not implemented"
    end

    def zip
      raise "not implemented"
    end
#  end
end
