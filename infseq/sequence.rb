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
    FilterSequence.new(block, self)#.succ
  end

  def detect(&block)
    iter = nil
    each do |x|
      if block.call(x)
        iter = x
        break
      end
    end
    iter
  end

  def reject(&block)
    rej = lambda { |blk, k| !blk.call(k) }.curry.call(block)
    select(&rej)
  end

  def reverse
    ReversedSequence.new(self)
  end

  def each(&blk)
    return self unless block_given?
    n = self
    loop do
      yield(n)
      n = n.succ
    end
    self
  end

  def each_with_index(&block)
    return MapSequence.new(lambda { |init| lambda{ |x| [x, init+=1] } }.call(-1), self) unless block_given?
    idx = -1
    each do |x|
      block.call(x, idx+=1)
    end
    self
  end

  def first(n=nil)
    counter = lambda { |size, idx| lambda { |dont_care| (idx+=1) <= size } }.call(n||1, 0)
    batch = take_while(&counter)
    n ? batch : batch.first
  end

  def take_while(&test)
    batch = []
    each do |x|
      break unless test.call(x)
      batch << x
    end
    batch
  end

  def take_until(&test)
    take_while { |x| !test.call(x) }
  end

  def from(lower, inclusive=true)
    filter = inclusive ? lambda { |x| x < lower } : lambda { |x| x <= lower }
    BoundedSequence.new(filter, self.detect { |x| !filter.call(x) })
  end

  def to(upper, inclusive=true)
    filter = inclusive ? lambda { |x| x > upper } : lambda { |x| x >= upper }
    BoundedSequence.new(filter, self.detect { |x| !filter.call(x) })
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
