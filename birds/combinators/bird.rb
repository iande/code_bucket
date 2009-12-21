module Combinators
  class Functional
    def initialize(proc)
      @invokation = proc
    end

    def call(*args)
      @invokation.call(*args)
    end

    def arity
      @invokation.arity
    end

    def to_s
      "F[#{@invokation.arity}]"
    end

    def inspect
      "[#{to_s}]"
    end

    def to_sym
      to_s.to_sym
    end
  end

  class Bird
    attr_reader :name
    def initialize(name, proc, params=[])
      @name = name.to_sym
      @parameters = params
      @invokation = proc
    end

    def to_s
      to_sym.to_s
    end

    def arity
      @invokation.arity - @parameters.size
    end

    def to_sym
      @name
    end

    def call(bird)
      if bird.is_a?(Symbol) || bird.is_a?(Proc)
        bird = (bird.respond_to?(:call)) ? Functional.new(bird) : SymbolicFunctional.new(bird)
      end
      if arity == 0
        @invokation.call(*@parameters).call(bird)
      else
        Bird.new("(#{self}#{bird})", @invokation, @parameters + [bird])
      end
    end

    def inspect
      "<#{to_s}>"
    end
  end

  class SymbolicFunctional < Functional
    def initialize(symb)
      @name = symb.to_sym
    end

    def arity
      0
    end

    def call(other)
      SymbolicFunctional.new("(#{self}#{other})")
    end

    def to_sym
      @name
    end
    def to_s
      to_sym.to_s
    end
    def inspect
      to_s
    end
  end
end

module ::Kernel
  def bird(name=nil,&block)
    Combinators::Bird.new(name, block)
  end
end
