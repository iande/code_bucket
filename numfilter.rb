require 'infseq/well_ordered_enumerable'
require 'infseq/factoring'
require 'infseq/boundable'
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
NaturalNumbers    = BoundedBelowSequence.new(lambda { |x| x < 1 }, 1)
WholeNumbers      = BoundedBelowSequence.new(lambda { |x| x < 0 }, 0)
PrimeNumbers      = Primes.new
FibonacciNumbers  = Fibonacci.new

# Instances of Primes generate by the general rules of prime numbers in that
# given a starting number that is prime, its successor is the first number
# that is not divisible by the seed.  The successor of the successor is the
# next number that is not divisible by either of the previous two numbers, and
# so forth.  By default, Primes.new() creates a prime sequence seeded at the
# Fixnum of 2 and relies on Fixnum#succ to move along.  However, we can just as
# easily supply some other Fixnum seed, or even one of our own Sequences as a
# seed, as is the case here.  The Fibonacci Primes are all those members of
# the Fibonacci sequence that have no non-trivial devisors within the
# FibonacciSequence.  An example of a Fibonacci Prime that is not a Regular Prime
# is 4181, which is the 20th Fibonacci Number, but factors to: 37 * 113
FibonacciPrimes   = Primes.new(nil, Fibonacci.new(2,3))
