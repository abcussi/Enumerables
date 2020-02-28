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
    return Parm_any(par) unless par.nil?

    return (my_any? { |x| !x.nil? && x != false }) unless block_given?

    my_each do |a|
      return true if yield a
    end
    false
  end

  def Parm_any(par)
    if par.class == Class
      my_any? { |x| x.class == par }
    elsif par.class == Regexp
      my_any? { |x| x =~ par }
    else
      my_any? { |x| x == par }
    end
  end

  def my_none?(pattern = nil)
    if block_given?
      !my_any? { |x| yield x }
    elsif pattern
      !my_any?(pattern)
    else
      my_each { |x| return false if x }
      true
    end
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

  def my_map(*_parm)
    return to_enum unless block_given?

    arr = []
    my_each do |val|
      arr << (yield val)
    end
    arr
  end

  def my_inject(init = nil, sym = nil, &block)
    unless block_given?
      return inject_sym(init) if init.class == Symbol
      return inject_sym(sym, init) if sym

      raise 'No block nor symbol given'
    end
    return self[1..length].my_inject(self[0], &block) unless init

    my_each { |x| init = block.call(init, x) }
    init
  end

  def inject_sym(sym, init = nil)
    return self[1..length].inject_sym(sym, self[0]) unless init

    my_each { |x| init = init.send sym, x }
    init
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

puts multiply_els([2, 4, 5])
puts ['false','true',""].my_none?(/z/)
puts ["one", "", "true"].my_none?(/f/)
puts [1,false,"hello"].my_none?(Integer)