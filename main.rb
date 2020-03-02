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
    return parm_any(par) unless par.nil?

    return (my_any? { |x| !x.nil? && x != false }) unless block_given?

    my_each do |a|
      return true if yield a
    end
    false
  end

  def parm_any(par)
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

  def my_inject(nval = nil, nsym = nil, nproc = nil)
    temp_arr = to_a
    params = compare_params([temp_arr[0], :+, proc {}], [nval, nsym, nproc])
    total = nil
    temp_arr.unshift(params[0]) unless params[0].nil?
    return symbol_inject(params[1], temp_arr) unless params[1].nil?

    temp_arr.my_each_with_index do |value, index|
      total = if index.zero?
                value
              elsif params[2].nil?
                yield total, value
              else
                params[2].call(total, value)
              end
    end
    total
  end

  def symbol_inject(param, temp_arr)
    symbols = [[:+, '+'], [:-, '-'], [:*, '*'], [:/, '/'], [:**, '**'], [:&, '&&'], [:|, '||']]
    symbols.my_each do |value|
      return temp_arr.my_inject { |total, a| total.method(value[1]).call(a) } if param == value[0]
    end
  end

  def compare_params(types, params)
    new_params = Array.new(types.length, nil)
    i = types.length - 1
    while i >= 0
      j = 0
      while j < params.length
        if types[i].class == params[j].class
          new_params[i] = params[j]
          break
        end
        j += 1
      end
      i -= 1
    end
    new_params
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

puts multiply_els([2, 4, 5])
