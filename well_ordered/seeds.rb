require 'well_ordered/seeds/numerical'
require 'well_ordered/seeds/primal'
require 'well_ordered/seeds/fibonacci'

module WellOrdered
  module Seeds
    module Named
      Ints = Integers = IntegerBased.build_unbounded(0)
      Nats = NaturalNumbers = IntegerBased.build_bounded(1)
      Wholes = WholeNumbers = IntegerBased.build_bounded(0)
      Fibs = FibonacciNumbers = WellOrdered::Seeds::Fibonacci.new()
      Primes = PrimeNumbers = WellOrdered::Seeds::Primal.new(2)
      # Can't start at the regular point (0, 1), or we get divisors that don't make sense.
      FibPrimes = FibonacciPrimes = WellOrdered::Seeds::Primal.new(WellOrdered::Seeds::Fibonacci.new(2,3))
    end
  end
end