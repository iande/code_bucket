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
