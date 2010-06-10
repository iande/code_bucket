module Combinators
  class Functional
    def initialize(invokable=nil, params=[], name=nil, &block)
      @invokation = invokable || block
      @parameters = params
      if invokable.is_a?(Symbol) && name.nil?
        @name = invokable.to_s
      else
        @name = name
      end
    end

    def join(other)
      other = functionize(other)
      if ready?
        Functional.new(@invokation.call(*@parameters), [other], "(#{self}#{other})")
      else
        Functional.new(@invokation, @parameters + [other], "(#{self}#{other})")
      end
    end

    alias_method :^, :join

    def call(*args)
      if ready?
        if args.size > 0
          @invokation.call(*@parameters).call(*args)
        else
          @invokation.call(*@parameters)
        end
      else
        if args.size > 0
          (self ^ args.first).call(*(args[1..-1]))
        else
          self
        end
      end
    end

    def functionize(arg)
      if arg.is_a?(Proc) || arg.is_a?(Symbol)
        Functional.new(arg)
      else
        arg
      end
    end

    def arity
      @invokation.arity - @parameters.size
    end

    def ready?
      arity <= 0
    end

    # From here below is for debugging purposes!

    def to_s
      @final_name ||= (Functional.lookup(self) || @name).to_s
    end

    def self.lookup(func)
      if Combinators.const_defined?(:Constants)
        Combinators::Constants.constants.detect { |c| Combinators::Constants.const_get(c) == func }
      else
        nil
      end
    end
  end
end

class ::Symbol
  def arity
    1
  end

  def call(*args)
    args.inject(self) { |acc, a| "(#{acc}#{a})" }.to_sym
  end
end
