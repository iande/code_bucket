module WellOrdered
  module Sequences
    class Primal
      include WellOrdered::Sequences::Numerical
      
      def initialize(s=2, priors=nil)
        @base = s
        @known_primes = priors || []
        @known_primes << self
        @index_in_prior = @known_primes.size-1
      end

      def to_i
        @base.to_i
      end
      
      def succ
        if @known_primes.size > @index_in_prior+1
          @known_primes[@index_in_prior+1]
        else
          s = @base.succ
          s = s.succ while @known_primes.detect { |x| s % x.to_i == 0 }
          Primal.new(s, @known_primes)
        end
      end

      def pred
        raise StopIteration, "there is no prime successor to #{@base}" if @index_in_prior == 0
        @known_primes[@index_in_prior-1]
      end
    end
  end
end
