module WellOrdered
#  module Reverse
    def reverse
      WellOrdered::Reverser.new(self)
    end

    class Reverser
      include ::WellOrdered
      def initialize(base)
        @base = base
      end

      def succ
        Reverser.new(@base.pred)
      end

      def pred
        Reverser.new(@base.succ)
      end

      def method_missing(meth, *args, &block)
        @base.__send__(meth, *args, &block)
      end

      def to_s; @base.to_s; end
      def inspect; @base.inspect; end
    end
#  end
end
