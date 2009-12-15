class Fibonacci < Sequence
  pred { |prev| [ prev.last - prev.first, prev.first ] }
  succ { |prev| [ prev.last, prev.last + prev.first ] }
  curr { |prev| prev.first }

  def initialize(a=0, b=1)
    super
  end
end
