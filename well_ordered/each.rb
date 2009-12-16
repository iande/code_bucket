module WellOrdered
#  module Each
    def each
      return enum_for(:each) unless block_given?
      n = self
      loop do
        yield(n)
        n = n.succ
      end
    end

    # Only here for Enumerable compatibility.
    # Rather than implementing a reverse_<iter> method for
    # each iterator, it's probably better to use #reverse.<iter> instead
    def reverse_each
      return enum_for(:reverse_each) unless block_given?
      n = self
      loop do
        yield(n)
        n = n.pred
      end
    end
#  end
end
