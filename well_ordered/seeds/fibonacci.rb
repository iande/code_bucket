module WellOrdered
  module Sequences
    class Fibonacci
      RHO = (1 + Math.sqrt(5)) / 2.0

      include WellOrdered::Seeds::Numerical

      def initialize(a=0, b=1)
        @first = a
        @second = b
      end

      def to_i
        @first.to_i
      end

      def succ
        @succ ||= Fibonacci.new(@second, @second + @first)
      end

      def pred
        @pred ||= Fibonacci.new(@second - @first, @first)
      end

      def factor(n)
        raise "Buggy!"
        factors = super(n)
        if factors.all? { |x| include?(x.first) }
          factors
        else
          nil
        end
      end

      def include?(x)
        # Solves the problems associated with seeding with 0, 0 (which is silly)
        return true if x == @first || x == @second
        x = x.to_i
        # x must be divisible by the gcd of any two consecutive fibonacci numbers
        gdiv = @first.gcd(@second)
        if x % gdiv == 0
          self.class.is_fibonacci?(x/gdiv)
        else
          false
        end
      end

      # Applies only to the standard fibonacci sequence, but all other
      # variants can use this method.  This method's really only valid for
      # integers (things like 2.5 are included)
      def self.is_fibonacci?(n)
        n = n.to_i
        r1 = n * RHO
        r2 = 1.0 / n
        (r1 - r2).ceil <= (r1 + r2).floor
      end
    end
  end
end
