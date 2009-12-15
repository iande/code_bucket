class ReversedSequence < Sequence
  pred { |prev| [prev.first.succ] }
  succ { |prev| [prev.first.pred] }
  curr { |prev| prev.first }
  def initialize(seq)
    super
  end
end
