module Boundable
  
  # I think this could be done a bit better.
  # We definitely want the filtering system in place to only pick the appropriate
  # values and start us off right, but, consider PrimeNumbers.from(14).to(16)
  # Rather than being empty, this will actually iterate indefinitely.  Unlike
  # a generic "detect", we do know something about our detect, it is progressing
  # through a well-ordered sequence.  If at any point we hit something greater (or
  # less) than the desired bound, we know that the resulting set is empty.

  def from(lower, inclusive=true, result_finite=false)
    filter = inclusive ? lambda { |x| x < lower } : lambda { |x| x <= lower }
    BoundedBelowSequence.new(filter, self.detect { |x| !filter.call(x) }, result_finite)
  end

  def to(upper, inclusive=true, result_finite=false)
    filter = inclusive ? lambda { |x| x > upper } : lambda { |x| x >= upper }
    BoundedAboveSequence.new(filter, self.detect { |x| !filter.call(x) }, result_finite)
  end
end
