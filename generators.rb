class Fibonacci < InfiniteEnumeration
  attr_accessor :seeds

  def initialize(seed_1=0, seed_2 = 1)
    @seeds = [seed_1, seed_2]
  end

  def seq
    a,b = @seeds.first, @seeds.last
    loop do
      yield a
      a, b = b, a+b
    end
  end

  def +(other_seq)
    Fibonacci.new(@seeds.first + other_seq.seeds.first, @seeds.last + other_seq.seeds.last)
  end

  def -(other_seq)
    Fibonacci.new(@seeds.first - other_seq.seeds.first, @seeds.last - other_seq.seeds.last)
  end
end

class NaturalNumbers < InfiniteEnumeration
  def seq
    start = 1
    loop do
      yield start
      start += 1
    end
  end
end

class Primes < InfiniteEnumeration
  def seq
    # Sieve of Kind-Of-Eratosthenes
    known_primes = []
    num = 2
    loop do
      num += 1 while known_primes.detect { |k| num % k == 0 }
      known_primes << num
      yield num
    end
  end
end
