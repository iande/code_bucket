class Sequence
  include Factoring
  include WellOrderedEnumerable
  include Boundable
  
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
