


def k_nearest_neighbors(data, predict, k=3)
  if data.length >= k
    puts "Warning: K is set to a value less than total voting groups"
  end
  distances = []
  data.keys.each do |group|
    data[group].each do |features|
      distance = euclidean_distance(features, predict)
      distances << [distance, group]
    end
  end
  votes = distances.sort.first(k).map {|t| t[-1]}
  result = votes.max_by{|i| votes.count(i)}
  confidence = votes.count(result) / k.to_f
  [result, confidence]
end

def euclidean_distance(point_1, point_2)
  sum_of_squares = 0.0
  point_1.each_with_index do |point_1_coord, ind|
    sum_of_squares += (point_1_coord - point_2[ind]) ** 2
  end
  Math.sqrt(sum_of_squares)
end

full_data = File.open('./breast-cancer-wisconsin.data.txt').map do |line|
  line.split(',')[1..-1].map! { |num| num != '?' ? num.to_i : -99999 }
end

test_size = 0.2
train_set = {2 => [], 4 => []}
test_set = {2 => [], 4 => []}

train_data = full_data[0..(full_data.length*test_size).to_i]
test_data = full_data[-(full_data.length*test_size).to_i..-1]

train_data.each { |i| train_set[i[-1]] << i[0..-2]}
test_data.each { |i| test_set[i[-1]] << i[0..-2]}

correct = 0.0
total = 0.0

test_set.keys.each do |group|
  test_set[group].each do |data|
    vote, confidence = k_nearest_neighbors(train_set, data, 9)
    if group == vote
      correct += 1
    else
      puts confidence
    end
    total += 1
  end
end

puts "Total: #{total}\nCorrect:#{correct}\n\nAccuracy: #{correct/total}"

# 20% train size and test size gives an accuracy of 99.2 %
