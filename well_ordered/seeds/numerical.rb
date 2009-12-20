module WellOrdered
  module Seeds
    module Numerical
      include ::WellOrdered

      def to_s
        to_i.to_s
      end

      def inspect
        to_s
      end

      def method_missing(meth, *args, &block)
        to_i.__send__(meth, *args, &block)
      end

      def succ
        @succ ||= self.class.new(to_i.succ)
      end

      def pred
        @pred ||= self.class.new(to_i.pred)
      end

      def ==(other)
        to_i == other.to_i
      end

      def eql?(other)
        self.class == other.class && self == other
      end

      def [](index, length=nil)
        index, length = index.first, index.count if index.is_a?(Range)
        if length
          first(index+length)[index..-1]
        else
          first(index+1).last
        end
      end

      # Factors a number within the context of a sequence
      # That's the idea, anyway.
      # FIXME: the last action, taking whatever remains after
      # factoring out all the possible divisors and making it the
      # final factor, is fine for the Natural numbers.  However,
      # this element may not be a member of the underlying Numerical
      # system, in which case, the given number is not factorable in
      # the context of this set/sequence.  Consider the Fibonacci
      # sequence seeded at 2,3.  22 would factor to => [ [2, 1], [11, 1] ]
      # while 121 factors to => [ [121, 1] ].  The latter form is acceptable,
      # the former is not.  Either return nil, an empty arry, or [[num,1]] when
      # an element cannot be factored within the given sequence.
      def factor(num)
        num = num.to_i
        upper = Math.sqrt(num).ceil
        # Always neglect 1 and 0.
        divs = from(2).to(upper)
        factors = divs.inject([ [], num ]) do |acc, div|
          break(acc) if acc.last == 1
          exp = 0
          while ( acc.last % div == 0 )
            exp += 1
            acc[1] = acc[1] / div
          end
          acc.first << [div, exp] if exp > 0
          acc
        end
        if factors.last > 1
          factors.first << [factors.last, 1]
        end
        factors.first
      end
    end

    class IntegerBased
      include WellOrdered::Seeds::Numerical

      def initialize(seed=0)
        @seed = seed
      end

      def to_i
        @seed
      end

      def self.build_unbounded(seed)
        self.new(seed)
      end

      def self.build_bounded(seed)
        WellOrdered::Bounded.new(self.new(seed), seed)
      end
    end
  end
end