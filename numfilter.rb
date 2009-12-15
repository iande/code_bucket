require 'infseq/sequence'
require 'infseq/map_sequence'
require 'infseq/filter_sequence'
require 'infseq/sequence_pair'
require 'infseq/reversed_sequence'
require 'infseq/bounded_sequence'
require 'infseq/primes'
require 'infseq/fibonacci'
require 'infseq/naturals'


Integers          = Sequence.new(0)
PositiveIntegers  = Integers
NegativeIntegers  = Integers.reverse
NaturalNumbers    = BoundedSequence.new(lambda { |x| x < 1 }, 1)
WholeNumbers      = BoundedSequence.new(lambda { |x| x < 0 }, 0)
PrimeNumbers      = Primes.new
FibonacciNumbers  = Fibonacci.new
FibonacciPrimes   = Primes.new(nil, FibonacciNumbers)
