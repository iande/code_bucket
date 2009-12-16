module WellOrdered
  def from(lower, inclusive=true)
    detector = inclusive ? lambda { |x| x >= lower } : lambda { |x| x > lower }
    Bounded.new(self.detect(&detector), lower, nil)
  end

  def to(upper, inclusive=true)
    detector = inclusive ? lambda { |x| x <= upper } : lambda { |x| x < upper }
    Bounded.new(self.detect(&detector), nil, upper)
  end

  class Bounded
    include ::WellOrdered

    attr_reader :base

    def initialize(base, min=nil, max=nil)
      raise ArgumentError, "We are not bounded if neither min nor max are specified" unless min or max
      @min = min
      @max = max
      if base.is_a?(Bounded)
        @min = [@min, base.min].compact.max if base.bounded_below?
        @max = [@max, base.max].compact.min if base.bounded_above?
        @base = base.base
      else
        @base = base
      end
    end

    def pred
      p = @base.pred
      raise StopIteration, "bounded below by #{@min}" if @min && p < @min
      Bounded.new(p, @min, @max)
    end

    def succ
      s = @base.succ
      raise StopIteration, "bounded above by #{@max}" if @max && s > @max
      Bounded.new(s, @min, @max)
    end

    def bounded_above?
      @max ? true : false
    end

    def bounded_below?
      @min ? true : false
    end

    def bounded?
      bounded_below? && bounded_above?
    end

    def min
      raise "sequence is not bounded below" unless @min
      @min
    end

    def max
      raise "sequence is not bounded above" unless @max
      @max
    end

    def method_missing(meth, *args, &block)
      @base.__send__(meth, *args, &block)
    end

    def to_a
      raise "can't make an array of an unbounded sequence" unless bounded_above? && bounded_below?
      acc = []
      each do |x|
        acc << x
      end
      acc
    end

    def inject(start=nil, &block)
      raise "can't inject with an unbounded sequence" unless bounded_above? && bounded_below?
      acc = start || 0
      each do |x|
        acc = yield(acc, x)
      end
      acc
    end

    def to_s
      @base.to_s
    end

    def inspect
      @base.inspect
    end
  end
end
