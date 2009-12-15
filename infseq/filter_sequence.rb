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
    filter, base, tested = *prev
    tested ? base : nil
  end

  def initialize(filter, base, tested=true)
    super(filter, base, tested)
  end
end
