require 'renumerable'

class Naturals
  include Renumerable

  def initialize(start=1)
    @start = start
  end

  def succ
    v = @start
    loop do
      begin
         yield(v)
         v = v.succ
      rescue StopIteration
        break
      end
    end
  end
end
