module WellOrdered
  #module Map
    def map(&block)
      return enum_for(:each) unless block_given?
      WellOrdered::Mapper.new(self, block)
    end

    alias collect map

    class Mapper
      include ::WellOrdered
      def initialize(base, transform, mapped=nil)
        @base = base
        @transform = transform
        @mapped = @transform.call(@base)
      end

      def succ
        Mapper.new(@base.succ, @transform)
      end

      def pred
        Mapper.new(@base.pred, @transform)
      end

      def method_missing(meth, *args, &block)
        @mapped.__send__(meth, *args, &block)
      end

      def to_s; @mapped.to_s; end
      def inspect; @mapped.inspect; end
    end
  #end
end
