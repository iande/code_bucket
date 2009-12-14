class InfiniteEnumeration
  def seq
    raise "Abstract Infinite Sequence has no sequence generator"
  end

  def each_with_index(&block)
    if block_given?
      idx = -1
      map { |n| [n, idx+=1] }.each(&block)
    else
      enum_for(:each_with_index)
    end
  end

  def each
    if block_given?
      seq do |v|
        yield v
      end
    else
      self
    end
  end

  def first(n=1)
    raise "Number to collect must be > 0" if n <= 0
    finite_collection = []
    idx = 0
    each do |v|
      finite_collection << v
      idx += 1
      break if idx == n
    end
    n > 1 ? finite_collection : finite_collection.first
  end

  def any?
    any_match = false
    each do |v|
      if yield(v)
        any_match = true
        break
      end
    end
    any_match
  end

  def cycle(n=nil, &block)
    if n
      first(n).cycle(&block)
    else
      each(&block)
    end
  end

  def drop(n)
    shifter = lambda { |shift|
      idx = 0
      lambda { |k|
        idx += 1
        idx > shift
      }
    }
    AcceptingInfiniteEnumeration.new(self, shifter.call(n))
  end

  def drop_while(&block)
    shifter = lambda { |check|
      done_checking = false
      lambda { |k|
        done_checking ||= check.call(k)
      }
    }
    AcceptingInfiniteEnumeration.new(self, shifter.call(block))
  end

  def [](index, end_at=nil)
    index, end_at = index.first, index.last if index.is_a?(Range)
    if end_at
      first(end_at+1)[index..-1]
    else
      first(index+1).last
    end
  end

  def map(&block)
    block_given? ? TransformingInfiniteEnumeration.new(self, &block) : self
  end

  def inspect
    '{' + first(5).inject('') { |acc, k| acc + k.to_s + ', '} + '...}'
  end

  def to_s; inspect; end

  # If the result is a collection
  # the "each" method on that collection would
  # yield only those values from the underlying sequence
  # that match the selector.
  def select(&block)
    block_given? ? AcceptingInfiniteEnumeration.new(self, &block) : self
  end
  
  def detect(&block)
    select(&block).first
  end

  def reject(&block)
    # Returning self if no block is given makes no freaking sense to me
    # (seems like we should reject everything, thus yielding an empty collection)
    # but it's the behavior given to Array, so we'll run with it.
    rejector = lambda { |if_true|
      lambda { |v|
        !if_true.call(v)
      }
    }
    block_given? ? AcceptingInfiniteEnumeration.new(self, rejector.call(block)) : self
  end
  
  alias find detect
  alias collect map
  alias find_all select
  # A bunch of methods will not work.  Such as sorting (how do we properly
  # sort an infinite set in a generic sense?), all? (how do we verify
  # a block is true for all elements of an infinite set in general?), and so
  # forth.
end

class AcceptingInfiniteEnumeration < InfiniteEnumeration
  def initialize(base_enum, &block)
    @sequencer = base_enum
    @included = block
  end

  def each
    if block_given?
      @sequencer.seq do |v|
        yield v if @included.call(v)
      end
    else
      enum_for(:each)
    end
  end
end

class TransformingInfiniteEnumeration < InfiniteEnumeration
  def initialize(base_enum, &block)
    @sequencer = base_enum
    @transform = block
  end

  def each
    if block_given?
      @sequencer.seq do |v|
        yield @transform.call(v)
      end
    else
      enum_for(:each)
    end
  end
end
