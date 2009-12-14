class Fibonacci
  include Enumerable
  attr_accessor :seeds

  def initialize(seed_1=0, seed_2 = 1)
    @seeds = [seed_1, seed_2]
  end

  def each
    if block_given?
      a,b = @seeds.first, @seeds.last
      loop do
        yield a
        a, b = b, a+b
      end
    else
      enum_for(:each)
    end
  end

  def [](index_start_at, end_at=nil)
    if end_at
      first(end_at+1)[index_start_at..-1]
    else
      if index_start_at.is_a?(Range)
        first(index_start_at.last+1)[index_start_at.first..-1]
      else
        first(index_start_at+1).last
      end
    end
  end

  def +(other_seq)
    Fibonacci.new(@seeds.first + other_seq.seeds.first, @seeds.last + other_seq.seeds.last)
  end

  def -(other_seq)
    Fibonacci.new(@seeds.first - other_seq.seeds.first, @seeds.last - other_seq.seeds.last)
  end
end

class Primes
  include Enumerable

  def each
    if block_given?
      known_primes = []
      num = 2
      loop do
        num += 1 while known_primes.detect { |k| num % k == 0 }
        known_primes << num
        yield num
      end
    else
      enum_for(:each)
    end
  end
end

# Let F_{n+2} = F_{n+1} + F_{n}; F_0 = a, F_1 = b
# Let A_{n+2} = A_{n+1} + A_{n}; A_0 = c, A_1 = d
# Let Q_{n+2} = Q_{n+1} + Q_{n}; Q_0 = c-a, Q_1 = d-b
# F_2 = b + a
# A_2 = d + c
# Q_2 = (d-b) + (c-a) = d + c - (b + a) = A_2 - F_2
# F_3 = (b+a) + b
# A_3 = (d+c) + d
# Q_3 = ((d-b) + (c-a)) + (d-b) = d - b + c - a + d - b = (d+c) + d - ( (b+a) + b ) = A_3 - F_3
# Proof by induction is here.
