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
