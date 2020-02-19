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
end

example_one = ["one","two","three","four","five"]
#puts 'my_each test'
#example_one.my_each do |items|
#  puts "show #{items}"
#end
#puts 'my_each_with_index test' 
#example_one.my_each_with_index { |n, i| puts "number : #{i+1} is: #{n}" }
#puts 'my_select test' 
#puts [1, 2, 4, 5, 8, 11].my_select { |n| n > 2 }
#puts 'my all test' 
#puts example_one.my_all?{|a| a.length > 2}
