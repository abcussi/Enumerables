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
end

example_one = ["one","two","three","four","five"]
puts 'my_each test'
example_one.my_each do |items|
  puts "show #{items}"
end