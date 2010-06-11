# To change this template, choose Tools | Templates
# and open the template in the editor.

module Lsystem
  class Axiom
    attr_reader :seed

    def initialize(seed)
      @seed = seed
    end

    def expand_once
      @seed
    end

    def apply(production)
      Lsystem::ProducedProxy.new(self, production)
    end
  end
end
