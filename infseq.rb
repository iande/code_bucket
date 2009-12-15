class NaturalEnumeration
  include Enumerable

  def initialize(base_seq=nil, &block)
    @base_seq = base_seq

    generates do |seq, n|
      seq[n] = seq[n-1].succ
    end
    seeds 1

    if block_given?
      if block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end
  end

  def each
    return self unless block_given?
    n = 0
    loop do
      yield mapping(n+=1)
    end
  end

  def select(&block)
    NaturalEnumeration.new(self) do
      generates do |seq, n|
        puts "Generatring the #{n}th selection"
        k = seq[n-1].succ
        until block.call(k)
          k = k + 1
        end
        puts "And the #{n}th selection is #{k}"
        seq[n] = k
      end
      #seeds(*@seq_seeds)
    end
  end

  def reject(&block)
    NaturalEnumeration.new(self) do
      generates do |seq, n|
        k = seq[n-1].succ
        while block.call(k)
          k = k + 1
        end
        seq[n] = k
      end
      #seeds(*@seq_seeds)
    end
  end

  def map(&block)
    NaturalEnumeration.new(self) do
      generates { |seq, n| seq[n] = block.call(n) }
      seeds(*@seq_seeds)
    end
  end

  def drop(k)
    NaturalEnumeration.new(self) do
      generates(&@seq_gen)
      seeds k+1
    end
  end

  def generates(&block)
    @seq_gen = block
    @seq_hash = Hash.new(&block)
  end

  def seeds(*args)
    @seq_seeds = []
    args.each_with_index do |seed, idx|
      @seq_hash[idx+1] = seed
      @seq_seeds << seed
    end
  end

  def modulo(n)
    map { |k| k % n }
  end

  def [](index, length=nil)
    index, length = index.first, index.count if index.is_a?(Range)
    if length
      first(index+length)[index..-1]
    else
      first(index+1).last
    end
  end

  def occurrence_of(subseq, offset=0)
    comp_at = 0
    starts_at = -1
    each_with_index do |k, idx|
      next if idx < offset
      if k == subseq[comp_at]
        comp_at += 1
      else
        comp_at = 0
      end
      if comp_at == subseq.size
        starts_at = idx - comp_at + 1
        break
      end
    end
    starts_at
  end

  def maybe_period?(period, offset=0, up_to=100)
    last_slice = nil
    maybe_periodic = true
    self[offset, up_to].each_slice(period) do |slice|
      if last_slice && slice.size == period
        maybe_periodic = maybe_periodic && (last_slice == slice)
      end
      last_slice = slice
      break unless maybe_periodic
    end
    maybe_periodic
  end

  def grouped(k)
    enum = NaturalEnumeration.new(self)
    enum.instance_eval <<-EOS
      def each(&block)
        return self unless block_given?
        n = 0
        collecting = []
        loop do
          collecting << mapping(n+=1)
          if collecting.size == #{k}
            yield(collecting)
            collecting = []
          end
        end
      end
    EOS
    enum
  end

  def consecutively(k)
    enum = NaturalEnumeration.new(self)
    enum.instance_eval <<-EOS
      def each(&block)
        return self unless block_given?
        n = 0
        collecting = []
        loop do
          collecting << mapping(n+=1)
          if collecting.size == #{k}
            yield(collecting)
            collecting = []
            n = n - #{k} + 1
          end
        end
      end
    EOS
    enum
  end

  alias_method :%, :modulo

  def mapping(n)
    n = @base_seq.mapping(n) if @base_seq
    if @seq_hash
      @seq_hash[n]
    else
      n
    end
  end
end

class DivisibilityFilter

end

class Primes < NaturalEnumeration
  def initialize()
    super() do
      generates do |seq, n|
        k = seq[n-1] + 1
        while seq.values.detect { |v| k % v == 0 }
          k += 1
        end
        seq[n] = k
      end
      seeds 2
    end
  end

  def factors_of(num)
    factor(num).first
  end

  def factor(num)
    pr = take_while { |p| p <= num }
    pr.inject([ [], [] ]) do |acc, p|
      if (num % p == 0)
        exp = 0
        while num > 0 && (num % p == 0)
          exp += 1
          num = num / p
        end
        acc.first << p
        acc.last << exp
      end
      acc
    end
  end
end

class Fibonacci < NaturalEnumeration
  def initialize(seed_1=0, seed_2=1)
    super() do
      generates { |seq, n| seq[n] = seq[n-1] + seq[n-2] }
      seeds seed_1, seed_2
    end
  end
end

module MathHelpers
  def gcd
    args = self.uniq
    return args.first if args.size <= 1
    start = args.pop
    args.inject(start) do |acc, v|
      v.gcd(acc)
    end
  end

  def lcm
    args = self.uniq
    return args.first if args.size <= 1
    start = args.pop
    args.inject(start) do |acc, v|
      v.lcm(acc)
    end
  end

  def gcd_2(a, b)
    while a > 0
      a, b = b % a, a
    end
    b
  end

  def lcm_2(a, b)
    a * b / gcd_2(a,b)
  end

  def pr_gcd
    args = self.uniq
    return args.first if args.size <= 1
    start = args.pop
    args.inject(start) do |acc, v|
      gcd_2(acc, v)
    end
  end

  def pr_lcm
    args = self.uniq
    return args.first if args.size <= 1
    start = args.pop
    args.inject(start) do |acc, v|
      lcm_2(acc, v)
    end
  end
end

::Array.send(:include, MathHelpers)