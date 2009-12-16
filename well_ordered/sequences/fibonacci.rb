module WellOrdered
  module Sequences
    class Fibonacci
      include WellOrdered::Sequences::Numerical

      def initialize(a=0, b=1)
        @first = a
        @second = b
      end

      def to_i
        @first.to_i
      end

      def succ
        @succ ||= Fibonacci.new(@second, @second + @first)
      end

      def pred
        @pred ||= Fibonacci.new(@second - @first, @first)
      end
    end
  end
end
