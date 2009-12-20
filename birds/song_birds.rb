# encoding: utf-8
module SongBirds
  class Bird2
    def initialize(sym=nil, &block)
      @symbol = (sym) ? sym.to_sym : :'(NoName)'
      @proc = block
    end

    def hears(other_bird)
      other_bird ? Bird.new("(#{self}#{other_bird})", lambda {
          @proc.call(other_bird)
        }) : @proc.call
    end

    def call(other, alt_sym=nil)
      hears(other)
    end

    def sings_to(other_bird)
      other_bird.hear(self)
    end

    def apply
      hears(nil)
    end

    def symbol=(sym); @symbol = sym.to_sym; end
    def to_s; @symbol.to_s; end
    def to_sym; @symbol; end
  end

  class Bird
    def initialize(sym, p)
      @symbol = (sym) ? sym.to_sym : :'(NoName)'
      @proc = p
    end

    def call(arg, sym=nil)
      sym ||= "(#{self}#{arg})".to_sym
      r = @proc.call(arg)
      r.is_a?(Proc) ? Bird.new(sym, r) : r
    end

    def to_sym; @symbol; end
    def to_s; @symbol.to_s; end
  end

  class ::Symbol
    def call(arg)
      "(#{self}#{arg})".to_sym
    end
  end

  IdiotBird = Bird.new(:I, lambda { |x| x })
  Starling = Bird.new(:S, lambda { |x,y,z| x.call(z).call(y.call(z)) }.curry)
  Kestrel = Bird.new(:K, lambda {|x,y| x }.curry)
  BlueBird = Bird.new(:B, lambda { |x,y,z| x.call(y.call(z)) }.curry)
  Turing = Bird.new(:U, lambda { |x,y| y.call(x.call(x).call(y)) }.curry)


#  IdiotBird = Bird.new(:I) { |x| x }
#  Starling = Bird.new(:S) { |x,y,z| x.call(z).call(y.call(z)) }
#  Kestrel = Bird.new(:K, lambda { |x,y| lambda { x } }.curry)
#
#  BlueBird = Bird.new(:B, lambda { |x,y,z| lambda { x.call(y.call(z)) } }.curry)
#  QueerBird = Bird.new(:Q, lambda { |x,y,z| lambda { y.call(x.call(z)) } }.curry)
#  QuixoticBird = Bird.new(:Q1, lambda { lambda { |x,y,z| x.call(z.call(y)) } }.curry)
#  QuizzicalBird = Bird.new(:Q2, lambda { lambda { |x,y,z| y.call(z.call(x)) } }.curry)
#  QuirkyBird = Bird.new(:Q2, lambda { lambda { |x,y,z| z.call(x.call(y)) } }.curry)
#  QuackyBird = Bird.new(:Q2, lambda { lambda { |x,y,z| z.call(y.call(z)) } }.curry)
#
#  Lark = Bird.new(:L, lambda { |x,y| lambda { y.call(y.call(y)) } }.curry)
#
#  MockingBird = Bird.new(:M, lambda { |x| lambda { x.call(x) } })
#  Warbler = Bird.new(:W, lambda { |x, y| lambda { x.call(y).call(y) } }.curry)
#  DoubleMockingBird = BlueBird.call(MockingBird, :M2)
#
#  Cardinal = Bird.new(:C, lambda { |x,y,z| lambda { x.call(z).call(y) } }.curry)
#  Robin = Bird.new(:R, lambda { |x,y,z| lambda { y.call(z).call(x) } }.curry)
#  Thrush = Bird.new(:T, lambda { |x,y| lambda { y.call(x) } }.curry)
#
#  Turing = Bird.new(:U, lambda { |x,y| lambda { y.call(x.call(x).call(y)) } }.curry)
#  Owl = Bird.new(:O, lambda { |x,y| lambda { y.call(x.call(y)) } }.curry)
#  Sage = Turing.call(Turing, :Y1)
#  Why = Starling.call(Lark).call(Lark, :Y)

  FactGen = lambda do |fact|
    lambda do |n|
      (n == 0) ? 1 : n * fact.call(n-1)
    end
  end

  AgentGen = lambda do |agent|
    lambda do |n, x|
      (n == 0) ? 1 : n * ( x + agent.call(n-1, x-1) )
    end
  end

  Ycomb = lambda do |f|
    lambda do |x|
      puts "I'm calling f!"
      f.call(lambda { |*y| puts "This fella's being called: #{y.inspect}!"; x.call(x).call(*y) })
    end.call( lambda { |x| f.call(lambda { |*y| puts "This outer fella is being called: #{y.inspect}!"; x.call(x).call(*y) })} )
  end
  
  TuringTuring = Bird.new(:'(UU)', lambda do |x|
    lambda do |y|
      puts "I, the inner curry, was called!"
      x.call(lambda do |*p|
          puts "Called the inner with #{p.inspect}"
          t_yy = y.call(y)
          puts "Y called Y (inner)"
          t_yy.call(*p)
      end)
    end.call(lambda do |y|
        puts "I, the outer curry, was called!"
      x.call(lambda do |*p|
          puts "Called the outer with #{p.inspect}"
          tt_y = y.call(y)
          puts "Y called Y (outer)"
          tt_y.call(*p)
      end)
    end)
  end)

  FactGen2 = lambda do |fact|
    lambda do |n|
      (n == 0) ? 1 : n * fact.call.call(n-1)
    end
  end

  # Yes, this combination of TuringTuring and FactGen2 works
  # It is a problem with your approach to implementing combinatory logic
  # in Ruby.  By immediately invoking expressions when they have filled their
  # expected parameters, you are allowing recursion to happen at a level that,
  # theoretically, is fine, but in practice will never resolve.  Redefine
  # your approach to the birds.  Rewrite call as @proc.call.call(arg), then
  # evaluation is always deferred, right?

  Ycomb2 = lambda do |x|
    lambda { |f|
      f.call(f)
    }.call(lambda { |g|
        x.call(lambda { |*n| g.call(g).call(*n) })
    })
  end

  YAYC = lambda do |gen|
    lambda do |x|
      lambda do |*args|
        gen.call(x.call(x)).call(*args)
      end
    end.call(lambda do |x|
      lambda do |*args|
        gen.call(x.call(x)).call(*args)
      end
    end)
  end

end