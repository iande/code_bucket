module WellOrderedEnumerable
  def map(&block)
    return self unless block_given?
    MapSequence.new(block, self)
  end

  def select(&block)
    return self unless block_given?
    FilterSequence.new(block, self)#.succ
  end

  def detect(&block)
    iter = nil
    each do |x|
      if block.call(x)
        iter = x
        break
      end
    end
    iter
  end

  def reject(&block)
    rej = lambda { |blk, k| !blk.call(k) }.curry.call(block)
    select(&rej)
  end

  def each_with_index(&block)
    return MapSequence.new(lambda { |init| lambda{ |x| [x, init+=1] } }.call(-1), self) unless block_given?
    idx = -1
    each do |x|
      block.call(x, idx+=1)
    end
    self
  end

  def first(n=nil)
    counter = lambda { |size, idx| lambda { |dont_care| (idx+=1) <= size } }.call(n||1, 0)
    batch = take_while(&counter)
    n ? batch : batch.first
  end

  def take_while(&test)
    batch = []
    each do |x|
      break unless test.call(x)
      batch << x
    end
    batch
  end

  def take_until(&test)
    take_while { |x| !test.call(x) }
  end
end
