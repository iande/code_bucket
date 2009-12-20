module WellOrdered
  module Seeds
    class Fibonacci
      SQRT_5 = Math.sqrt(5)
      PHI = (1 + SQRT_5) / 2.0
      LOG_PHI = Math.log(PHI)
      LOG_5 = Math.log(5)
      LOG_5_2 = LOG_5 / 2.0
      NEG_PHI_INV = (1 - PHI)

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
        factors = super(n)
        if factors.all? { |x| include?(x.first) }
          factors
        else
          nil
        end
      end

      def include?(p)
        test_index = self.class.general_index(@first, @second, p).round
        self.class.general_at(@first, @second, test_index).round == p
      end

      # Applies only to the standard fibonacci sequence, but all other
      # variants can use this method.  This method's really only valid for
      # integers (things like 2.5 are included)
      def self.is_fibonacci?(n)
        n = n.to_i
        return true if n == 0
        r1 = n * PHI
        r2 = 1.0 / n
        chk = (r1+r2).floor != (r1-r2).floor
        return chk if n > 0
        index(n).round % 2 == 0
      end

      # Returns an approximate index for where the given number would
      # appear in the fibonacci sequence.  The returned index may not be
      # an Integer value.
      def self.index(p)
        return 0 if p == 0
        idx = ( ( LOG_5_2 + Math.log(p.abs) ) / LOG_PHI )
        (p < 0) ? -idx : idx
      end

      # Computes the Fibonacci number at index n, using the closed form:
      # F_n = ( phi^n - (1-phi)^n ) / sqrt(5)
      def self.at(n)
        #n = n.to_i
        (PHI ** n - NEG_PHI_INV ** n) / SQRT_5
      end

      # Computes the number at index n for any sequence of the form A_{n+2} = A_{n+1} + A_n
      # with seed values a, b.
      # Uses the identity: A(a, b, n) = bF(n) + aF(n-1)
      def self.general_at(a, b, n)
        #a, b, n = a.to_i, b.to_i, n.to_i
        return a if n == 0
        return b if n == 1
        b * at(n) + a * at(n-1)
      end

      def self.general_index(a, b, p)
        #a, b, p = a.to_i, b.to_i, p.to_i
        return 0 if p == a # Save a little time
        return 1 if p == b # Save a little more
        # Essentially, A(a,b,k) = p if F(k-1) = p / (b * PHI + a)
        index(p / ( b * PHI + a )) + (p > 0 ? 1 : -1)
      end
    end
  end
end
