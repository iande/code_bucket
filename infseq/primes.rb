class Primes < FilterSequence
  # By the filtering mechanism, a given prime's predecessors will not pass their own checks
  # thus:
  pred do |prev|
    filter, cur = *prev
    prior = filter.predecessor_for(cur.to_i)
    raise StopIteration, "#{prev[1]} is the min prime" unless prior
    [filter, prior]
  end

  def initialize(filter=nil, pred=2)
    if filter
      filter.add(pred)
    else
      filter = DivisorCheck.new(pred)
    end
    super(filter, pred)
  end

  class DivisorCheck
    def initialize(div=nil)
      @chain = []
      add(div) if div
    end
    def add(div)
      div = div.to_i
      @chain << div
    end
    def predecessor_for(k)
      idx = @chain.index(k)
      (idx && idx > 0) ? @chain[idx-1] : nil
    end
    def call(x)
      @chain.all? { |div| x % div != 0 }
    end
  end
end
