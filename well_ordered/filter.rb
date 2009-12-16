module WellOrdered
#  module Filter
    def select(&block)
      return enum_for(:each) unless block_given?
      WellOrdered::Selector.new(self, block)
    end

    def reject
      return enum_for(:each) unless block_given?
      select do |x|
        !yield(x)
      end
    end

    alias find_all select

    class Selector
      include ::WellOrdered
      def initialize(base, selector)
        @selector = selector
        @base = base
      end

      def succ
        s = @base.succ
        s = s.succ until @selector.check(s)
        Selector.new(s, @selector)
      end

      def pred
        p = @base.pred
        p = p.pred until @selector.check(p)
        Select.new(p, @selector)
      end

      def method_missing(meth, *args, &block)
        @base.__send__(meth, *args, &block)
      end

      def to_s; @base.to_s; end
      def inspect; @base.inspect; end
    end
#  end
end
