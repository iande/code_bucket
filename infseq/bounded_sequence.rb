class BoundedSequence < Sequence
  pred do |prev|
    check, cur = *prev
    unless check.call(cur.pred)
      [check, cur.pred, @finite]
    else
      raise StopIteration, "#{cur} has no predecessor in this sequence"
    end
  end
  succ do |prev|
    check, cur = *prev
    unless check.call(cur.succ)
      [check, cur.succ, @finite]
    else
      raise StopIteration, "#{cur} has no successor in this sequence"
    end
  end
  curr { |prev| prev.last }

  def initialize(bounds_check, cur, finite=false)
    super(bounds_check, cur)
    @finite = finite
  end
  
  def finite?
    @finite
  end
  
  def all(force=false)
    raise ArgumentError, "Sequence may not be fully bounded, call as all(true) to force" unless finite? or force
    collected = []
    each do |x|
      collected << x
    end
    collected
  end
end

class BoundedAboveSequence < BoundedSequence
  # if we're bounded above, and given a below:
  def from(num, inclusive=true)
    super(num, inclusive, true)
  end
end

class BoundedBelowSequence < BoundedSequence
  # if we're bounded below, and given an above:
  def to(num, inclusive=true)
    super(num, inclusive, true)
  end
end
