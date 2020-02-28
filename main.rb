module Enumerable
  def my_each
    return to_enum unless block_given?

    y = 0
    arr = to_a
    while y < arr.length
      yield arr[y]
      y += 1
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    y = 0
    arr = to_a
    while y < arr.length
      yield arr[y], y
      y += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    access = []
    my_each do |val|
      access << val if yield val
    end
    access
  end

  def my_all?(par = nil)
    return test_parm(par) unless par.nil?

    return (my_all? { |x| !x.nil? && x != false }) unless block_given?

    my_each do |a|
      return false unless yield a
    end
    true
  end

  def test_parm(par)
    if par.class == Class
      my_all? { |x| x.class == par }
    elsif par.class == Regexp
      my_all? { |x| x =~ par }
    else
      my_all? { |x| x == par }
    end
  end

  def my_any?(par = nil)
    return test_param_any(par) unless par.nil?

    return (my_any? { |x| !x.nil? && x != false }) unless block_given?

    my_each do |a|
      return true if yield a
    end
    false
  end

  def test_param_any(par)
    if par.class == Class
      my_any? { |x| x.class == par }
    elsif par.class == Regexp
      my_any? { |x| x =~ par }
    else
      my_any? { |x| x == par }
    end
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg = nil,&block)
  end

  def my_count(par = nil)
    cnt = 0
    return my_count { |x| x == par } unless par.nil?
    return (my_count { |_x| true }) unless block_given?

    my_each do |a|
      cnt += 1 if yield a
    end
    cnt
  end

  def my_map (*parm)
    return to_enum unless block_given?

    arr = []
    my_each do |val|
      arr << (yield val)
    end
    arr
  end
  
  def my_inject(int = nil, sym = nil)
  x = 1
  res = self[0]
  sym, int = int, sym if int.is_a? Symbol
  if int
    res = int
    x = 0
  end

  while x < length
    res = if block_given?
             yield res, self[x]
           else
             res.send(sym, self[x])
           end
    x += 1
  end
  res
end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

puts multiply_els([2, 4, 5])