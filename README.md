# Code Bucket

Just a dumping area for some random code that pops into my brain.


## Sequences

Doing some work on allowing unbounded (but countable) sequences to be handled
similarly to other Enumerable collections in Ruby.  I've attempted several
different approaches found in:

1. infinite_enumeration.rb (and generators.rb)
1. infseq.rb
1. numfilter.rb (and everything in infseq/ directory)
1. well_ordered.rb (and everything in well_ordered/ directory)

well_ordered.rb is the start of my refactoring.  After a days journey through
coding, we're starting to arrive at something I like.  The name isn't accurrate
with regard to the set theoretic definition of *wellorder*, I'm just not sure
what else to call it at this time.  To use the WellOrdered
module, one need only define the `succ` and `pred` instance methods that return
the current object's successor and predecessor, respectively.  To be able to
manipulate things as countably infinite sequences, it may be helpful to use
`method_missing`, or some other delegation method, to hand off unknown messages
to a base object.  Who knows if this will be useful to anyone, myself included,
but it's been a fun exercise so far.  This task was started on Ruby 1.8.7, but
I have been doing later development of it in Ruby 1.9.  I have no intention of
testing it against Ruby 1.8.x at this time (though I can almost guarantee that
it will not work with 1.8.6 and lower, due to `each` returning an Enumerator
unless a block is provided.)  Where possible, I try to let Enumerator/Enumerable
do the work for me.  Such as with `detect`, `first`, and so forth.  There are
some methods that I don't feel are generally implementable (`min`, `max`, etc.)
and some that I either can't think of an appropriate analogue for (eg: `inject`)
or haven't bothered to implement yet (`drop`, `drop_while`).

## Song Birds

The `birds` directory contains my first few stabs at implementing Raymond Smullyan's
song birds (combinators) in terms of Ruby lambda objects.  They work, mostly.  There
is an issue with Y-combinators (Sage birds) and recursion in general due to how
I initially handled combinator evaluation and Ruby's evaluation of parameters to
a method before invoking the method.  In short, a straight-forward attempt at making
a Y-combinator from composing two Turing birds results in infinite recursion because
the recursion portion of the combinatory expression is evaluated in an unbounded
fashion, and the underlying function is never once invoked.  I'm working on resolving
this now by considering a different approach, though this approach may convince me
that Ruby isn't an appropriate place to think about things in terms of combinators.

## Legal Jazz

All code here was written by Ian D. Eccles unless otherwise noted.
Software is released under the Apache License 2.0, unless otherwise noted.
