module Factoring
  def factor(num)
    num = num.to_i
    raise ArgumentError, "cannot factor #{num}" if num <= 1
    if num <= self
      [num, 1]
    else
      upper = (Math.sqrt(num)).ceil
      div = from(2).to(upper)
      acc = [ [], num ]
      loop do
        break if acc.last == 1
        exp = 0
        while (acc.last % div == 0)
          exp += 1
          acc[1] = acc[1] / div
        end
        acc.first << [div, exp] if exp > 0
        div = div.succ
      end
      if acc.last > 1
        acc.first << [acc.last, 1]
      end
      acc.first
    end
  end

  def factors_of(num)
    factor(num).map { |(prime,exp)| prime }
  end
end

# Generalizing this for any sequence, not just Fixnum.

#      factors = divisors.inject([ [], num]) do |acc, div|
#        break(acc) if acc.last == 1
#        exp = 0
#        while (acc.last % div == 0)
#          exp += 1
#          acc[1] = acc[1] / div
#        end
#        acc.first << [div, exp] if exp > 0
#        acc
#      end
#      if factors.last > 1
#        factors.first << [factors.last, 1]
#      end
#      factors.first