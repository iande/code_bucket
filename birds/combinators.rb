require 'birds/combinators/bird'

module Combinators
  module Named
    # Names and definitions of birds taken from Raymond P. Smullyan's
    # "To Mock a Mocking Bird", pp. 244-245

    B = bird(:Blue) { |x,y,z| x.call(y.call(z)) }
    C = bird(:Cardinal) { |x,y,z| x.call(y).call(z) }
    D = bird(:Dove) { |x,y,z,w| x.call(y).call(z.call(w)) }
    E = bird(:Eagle) { |x,y,z,w,v| x.call(y).call(z.call(w).call(v)) }
    F = bird(:Finch) { |x,y,z| z.call(y).call(x) }
    G = bird(:Goldfinch) { |x,y,z,w| x.call(w).call(y.call(z)) }
    H = bird(:Humming) { |x,y,z| x.call(y).call(z).call(y) }
    I = bird(:Identity) { |x| x }
    J = bird(:Jay) { |x,y,z,w| x.call(y).call(x.call(w).call(z)) }
    K = bird(:Kestrel) { |x,y| x }
    L = bird(:Lark) { |x,y| x.call(y.call(y)) }
    M = bird(:Mocking) { |x| x.call(x) }
    O = bird(:Owl) { |x,y| y.call(x.call(y)) }
    Q = bird(:Queer) { |x,y,z| y.call(x.call(z)) }
    Q1 = bird(:Quixotic) { |x,y,z| x.call(z.call(y)) }
    Q3 = bird(:Quirky) { |x,y,z| z.call(x.call(y)) }
    R = bird(:Robin) { |x,y,z| y.call(z).call(x) }
    S = bird(:Starling) { |x,y,z| x.call(z).call(y.call(z)) }
    T = bird(:Thrush) { |x,y| y.call(x) }
    U = bird(:Turing) { |x,y| y.call(x.call(x).call(y)) }
    V = bird(:Vireo) { |x,y,z| z.call(x).call(y) }
    W = bird(:Warbler) { |x,y| x.call(y).call(y) }
    W1 = bird(:ConverseWarbler) { |x,y| y.call(x).call(x) }


    # A few sage birds, named for their "distinguishing" bird.
    # In truth, the naming is kind of arbitrary.
    YU = U.call(U)
    YS = S.call(L).call(L)
    YB = B.call(M).call(L)
    YQ = Q.call(Q.call(M)).call(M)
    Y = YS
  end
end