require 'well_ordered/sequences/numerical'
require 'well_ordered/sequences/primal'
require 'well_ordered/sequences/fibonacci'

module WellOrdered
  module Sequences
    module Named
      Ints = Integers = IntegerBased.build_unbounded(0)
      Nats = NaturalNumbers = IntegerBased.build_bounded(1)
      Wholes = WholeNumbers = IntegerBased.build_bounded(0)
      Fibs = FibonacciNumbers = WellOrdered::Sequences::Fibonacci.new()
      Primes = PrimeNumbers = WellOrdered::Sequences::Primal.new(2)
      # Can't start at the regular point (0, 1), or we get divisors that don't make sense.
      FibPrimes = FibonacciPrimes = WellOrdered::Sequences::Primal.new(WellOrdered::Sequences::Fibonacci.new(2,3))
    end
  end
end