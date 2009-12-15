class Primes < FilterSequence
  def initialize(cur=nil, pred=nil)
    pred ||= Naturals.new(2, nil)
    if cur
      filter = lambda { |x| cur.call(x) && x % pred != 0 }
    else
      filter = lambda { |x| x % pred != 0 }
    end
    super(filter, pred)
  end

  def factors_of(num)
    factor(num).first
  end

  def factor(num)
    pr = take_while { |p| p <= num }
    pr.inject([ [], [] ]) do |acc, p|
      if (num % p == 0)
        exp = 0
        while num > 0 && (num % p == 0)
          exp += 1
          num = num / p
        end
        acc.first << p
        acc.last << exp
      end
      acc
    end
  end
end
