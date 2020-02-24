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

  def my_all?
    return (my_all? { |a| !a.nil? }) unless block_given?

    my_each do |a|
      return false unless yield a
    end
    true
  end

  def my_any?
    return (my_any? { |x| !x.nil? }) unless block_given?

    my_each do |value|
      return true if yield value
    end
    false
  end

  def my_none?
    return (my_none? { |x| !x.nil? }) unless block_given?

    my_each do |val|
      return false if yield val
    end
    true
  end

  def my_count(nval = nil)
    cont = 0
    if !nval.nil?
      my_each do |value|
        cont += 1 if nval == value
      end
    else
      my_each do
        cont += 1
      end
    end
    cont
  end

  def my_map
    return to_enum unless block_given?

    new_array = []
    my_each do |value|
      new_array << (yield value)
    end
    new_array
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
  part = rand(1..3)
  case part
  when 1
    arr.my_inject { |total, a| total * a }
  when 2
    arr.my_inject(:*)
  when 3
    by_proc = proc { |total, a| total * a }
    arr.my_inject(by_proc)
  end
end

puts multiply_els([2, 4, 5])
