class BoundedSequence < Sequence
  pred do |prev|
    check, cur = *prev
    unless check.call(cur.pred)
      [check, cur.pred]
    else
      raise StopIteration, "#{cur} has no predecessor in this sequence"
    end
  end
  succ do |prev|
    check, cur = *prev
    unless check.call(cur.succ)
      [check, cur.succ]
    else
      raise StopIteration, "#{cur} has no successor in this sequence"
    end
  end
  curr { |prev| prev.last }


  def initialize(bounds_check, cur)
    super(bounds_check, cur)
  end
end
