module FixnumExtensions

  # Returns [x, y] such that x and y are solutions to:
  # self * x + b * y = self.gcd(b)
  def extended_gcd(b)
    return [0, 1] if self % b == 0
    x, y = b.extended_gcd(self % b)
    [y, x - y * (self / b)]
  end

end
