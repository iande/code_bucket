module Renumerable
  include Enumerable

  class Renumerator
    include Renumerable
    def initialize(base, &trans)
      @base = base
      @transform = trans || lambda { |x| x }
    end

    def each
      return to_enum :each unless block_given?

      @base.succ do |v|
        yield(@transform.call(v))
      end
    end
  end

  def map(&block)
    return self unless block_given?
    return Renumerator.new(self, &block)
  end

  def each
    return to_enum :each unless block_given?

    succ do |v|
      yield(v)
    end
  end
end
