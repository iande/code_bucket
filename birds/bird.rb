class Bird
  def initialize(as, proc=nil, &block)
    @as = as
    unless proc
      @proc = (block.arity > 1) ? block.curry : block
    else
      @proc = proc
    end
  end

  def call(bird=nil)
    puts "I #{self} was called with #{bird} [#{@proc}]"
    #unless bird.is_a?(Bird)
      #bird = Bird.new('', bird)
    #end
    r = (bird) ? @proc.call(bird) : @proc.call
    bird.is_a?(Bird) ? Bird.new("(#{self}#{bird})", r) : r
    #unless bird.is_a?(Bird)
      #(bird) ? @proc.call(bird) : @proc.call
    #else
      #Bird.new("(#{self}#{bird})", @proc.call(bird))
    #end
  end

  def arity; @proc.arity; end

  def to_s; @as; end
end


BlueBird = Bird.new("B") do |x,y,z|
  x.call(y.call(z))
end
MockingBird = Bird.new("M") do |x|
  puts "Mocking: #{x}"
  x.call(x)
end
Lark = Bird.new("L") do |x,y|
  #x.call(lambda { y.call(y) })
  x.call(y.call(y))
end
Kestrel = Bird.new("K") do |x,y|
  x
end
Idiot = Bird.new("I") do |x|
  x
end

Turing = Bird.new("U") do |x|
  lambda do |y|
    y.call(lambda { |*args|
      x.call(x).call(y).call(*args)
    })
  end
end

Why = Turing.call(Turing)

FactGen = lambda do |fact|
  # If you put fact.call here, you immediately evaluate x.call(x).call(y) which
  # re-evaluates the containing block: lambda { |y| y.call ... }.  That in turn
  # brings us back here to invoke fact.call again.
  # Because fact.call.call is made within the factorial definition below,
  # we do everything except when we get back here, we merely create the next
  # lambda expression for the factorial definition and then unwind the stack.
  # Accepting the parameters in the nested lambda does seem to work. Though
  # it's a bit of a hack.  We defer the processing of the stuff inside the
  # y.call invokation, so as to not infinitely recurse immediately.  We have
  # to give something else the ability to call the recursion only as much as
  # needed, and that something is the definition of factorial below.
  lambda do |n|
    (n==0) && 1 or n * fact.call(n-1)
  end
end

Factorial = Why.call(FactGen)
