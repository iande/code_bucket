# To change this template, choose Tools | Templates
# and open the template in the editor.

module Generative
  module Lsystem
    class Rules
      def initialize
        @productions = {}
      end

      def add(word, production)
        @productions[word] = production
      end

      def apply(axiom, n=1)
        n.times.inject(axiom) do |production, _|
          apply_once(production)
        end
      end

      private
      def apply_once(axiom)
        axiom.inject([]) do |product, word|
          @productions.has_key?(word) ? product + @productions[word] : product + [word]
        end
      end
    end
  end
end
