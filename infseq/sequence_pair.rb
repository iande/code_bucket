class SequencePair < Sequence
  pred { |prev| [prev.first.pred, prev.last.succ] }
  succ { |prev| [prev.first.pred, prev.last.succ] }
  curr { |prev| prev }

  def initialize(pred, succ=nil)
    succ ||= pred
    super(pred,succ)
  end

  def self.from(gen)
    SequencePair.new(gen, gen).succ
  end

  def first
    curr.first
  end

  def last
    curr.last
  end

  def succ
    prd = @seeds.first.pred rescue nil
    scc = @seeds.last.succ rescue nil
    # If both bounds were exceeded, we raise a StopIteration ourself
    raise StopIteration, "Reached the bounds of the sequence" unless prd || scc
    # If both bounds are valid, we return a new SequencePair
    if prd && scc
      SequencePair.new(prd, scc)
    else
      # Otherwise we collapse to the branch that has not hit a bound.
      prd ? prd : scc
    end
  end

  alias pred succ
end
