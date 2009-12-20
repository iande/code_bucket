module WellOrdered
  class Sequence
    def initialize(seed)
      @seed = seed
      @filtered = seed
    end

    def modulo(x)
      @filtered = WellOrdered::Mapper.new(@filtered, lambda { |n| n % x })
    end

    def -(seq)
    end
  end
end
