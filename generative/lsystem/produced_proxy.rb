# To change this template, choose Tools | Templates
# and open the template in the editor.

module Lsystem
  class ProducedProxy
    attr_reader :production

    def initialize(proxy, production)
      @proxy = proxy
      @production = production
    end

    def axiom
      return @proxy if @proxy.is_a?(Lsystem::Axiom)
      @proxy.axiom
    end

    def apply(production)
      self.class.new(self, production)
    end

    def expand_once
      @production.expand(@proxy.expand_once)
    end

    def expand(n=1)
      raise "expansion must be positive" if n < 1
      base = @proxy.expand_once
      (n-1).times do
        base = @production.expand(base)
      end
      base
    end
  end
end
