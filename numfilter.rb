class Sequence
  def initialize(*seeds)
    @seeds = seeds.empty? ? [0] : seeds
    yield(self) if block_given?
  end

  def curr
    @seeds.first
  end

  def to_i; curr.to_i; end

  def to_s; curr.to_s; end
  
  def inspect
    #down = first(3, :pred)
    #up = first(3)[1..-1]
    #'{ ' + down.reverse.join(', ') + ', ' + up.join(', ') + ' }'
    to_s
  end

  def pred
    self.class.new(@seeds.first.pred)
  end

  def succ
    self.class.new(@seeds.first.succ)
  end

  def method_missing(meth, *args, &block)
    to_i.send(meth, *args, &block)
  end

  def mod(other)
    MapSequence.new(lambda { |x| x % other }, self)
  end

  def map(&block)
    return self unless block_given?
    MapSequence.new(block, self)
  end

  def select(&block)
    return self unless block_given?
    FilterSequence.new(block, self).succ
  end

  def detect(&block)
    select(&block).first
  end

  def reject(&block)
    rej = lambda { |blk, k| !blk.call(k) }.curry.call(block)
    select(&rej)
  end

  def each(dir=:succ)
    return self unless block_given?
    n = self
    loop do
      yield(n)
      n = n.__send__(dir)
    end
    self
  end

  def each_with_index(dir=:succ, &block)
    return MapSequence.new(lambda { |init| lambda{ |x| [x, init+=1] } }.call(-1), self) unless block_given?
    idx = -1
    each(dir) do |x|
      block.call(x, idx+=1)
    end
    self
  end

  def first(n=nil, dir=:succ)
    counter = lambda { |size, idx| lambda { |dont_care| (idx+=1) <= size } }.call(n||1, 0)
    batch = take_while(dir, &counter)
    n ? batch : batch.first
  end

  def take_while(dir=:succ, &test)
    batch = []
    each(dir) do |x|
      break unless test.call(x)
      batch << x
    end
    batch
  end

  def take_until(dir=:succ, &test)
    take_while(dir) { |x| !test.call(x) }
  end

  class << self
    def pred(&blk)
      define_method(:pred) { @pred ||= self.class.new(*blk.call(@seeds)) }
    end

    def succ(&blk)
      define_method(:succ) { @succ ||= self.class.new(*blk.call(@seeds)) }
    end

    def curr(&blk)
      define_method(:curr) { @curr ||= blk.call(@seeds) }
    end
  end
end

class MapSequence < Sequence
  pred do |prev|
    trans, base = *prev
    base = base.pred
    [ trans, base, trans.call(base) ]
  end
  succ do |prev|
    trans, base = *prev
    base = base.succ
    [ trans, base, trans.call(base) ]
  end
  curr do |prev|
    prev.last
  end

  def initialize(trans, base, mapped=nil)
    mapped ||= trans.call(base)
    super(trans, base, mapped)
  end
end

class FilterSequence < Sequence
  pred do |prev|
    filter, base = *prev
    base = base.pred
    until filter.call(base)
      base = base.pred
    end
    [filter, base]
  end
  succ do |prev|
    filter, base = *prev
    base = base.succ
    until filter.call(base)
      base = base.succ
    end
    [filter, base]
  end
  curr do |prev|
    prev.last
  end

  def initialize(filter, base)
    super(filter, base)
  end
end

class Naturals < Sequence
  # Just like integers, but we start at 1 and never go lower.
  pred do |prev|
    if prev.last
      [ prev.last, prev.last.pred ]
    else
      raise StopIteration, "The natural number #{prev.first} has no predecessor"
    end
  end
  
  def initialize(a=1, pred=nil)
    super
  end
end

class Primes < FilterSequence
  def initialize(cur=nil, pred=nil)
    pred ||= Naturals.new(2, nil)
    if cur
      filter = lambda { |x| cur.call(x) && x % pred != 0 }
    else
      filter = lambda { |x| x % pred != 0 }
    end
    super(filter, pred)
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

class Fibonacci < Sequence
  pred { |prev| [ prev.last - prev.first, prev.first ] }
  succ { |prev| [ prev.last, prev.last + prev.first ] }
  curr { |prev| prev.first }

  def initialize(a=0, b=1)
    super
  end
end

class Modulo < Sequence
  pred do |prev|
    k = prev.last.pred
    mod = prev.first
    until (k % mod == 0)
      k = k.pred
    end
    [mod, k]
  end

  succ do |prev|
    k = prev.last.succ
    mod = prev.first
    until (k % mod == 0)
      k = k.succ
    end
    [mod, k]
  end

  curr { |prev| prev.last }

  def initialize(mod, start=0)
    super
  end
end
