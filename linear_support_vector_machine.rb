def every(n)
 select {|x| index(x) % n == 0}
end

class SupportVectorMachine
  def initialize(visualization=true)
    @visualization = visualization
    @colors = {1 => 'r',-1 => 'b' }

  end

  def fit(data)
    @data = data
    opt_hash = {}
    transforms = [[1,1],
                  [-1,1],
                  [-1,-1],
                  [1,-1]]

    all_data = @data.keys.map { |featureset| @data[featureset].flatten }.flatten
    @max_feature_value, @min_feature_value = all_data.max, all_data.min
    all_data = []
    step_sizes = [
      @max_feature_value * 0.1,
      @max_feature_value * 0.01,
      # point of expense
      @max_feature_value * 0.001
    ]

    b_range_multiple = 2
    b_multiple = 5
    latest_optimum = @max_feature_value*10
    step_sizes.each do |step|
      w = [latest_optimum, latest_optimum]
      optimized = false

      while !(optimized)
        (-1*(@max_feature_value*b_range_multiple)..@max_feature_value*b_range_multiple).step(step*b_multiple).to_a.each do |b|
            transforms.each do |transformation|
              w_t = transformation.map.with_index { |t, i| t*w[i] }
              found_option = true
              @data.keys.each do |i|
                @data[i].each do |xi|
                  yi = i
                  unless yi*((dot_product(w_t, xi))+b) >= 1
                    found_option = false
                  end
                end
              end
              if found_option == true
                opt_hash[euclidean_distance(w_t, [0,0])] = [w_t,b]
              end
            end
          end

        if w[0] < 0
          optimized = true
          puts "Optimized a step"
        else
          w = array_subtraction(w, step)
        end
      end
      norms = opt_hash.keys.sort
      opt_choice = opt_hash[norms[0]]
      @w = opt_choice[0]
      @b = opt_choice[1]
      latest_optimum = opt_choice[0][0]+step*2
    end

    @data.keys.each do |i|
      @data[i].each do |xi|
        yi = i
        puts "#{xi} : #{yi*((dot_product(@w, xi))+@b)}"
      end
    end

  end

  def predict(features)
    dot = dot_product(features, @w)
    x_w_b = dot + @b
    puts "#{@w}, #{@b}, #{@w_x_b}"
    classification = get_sign(x_w_b)
  end

  def dot_product(set_1, set_2)
    sums = 0
    set_1.each_with_index do |num, ind|
      sums += (num * set_2[ind])
    end
    sums
  end

  def get_sign(num)
    "0+-"[num <=> 0]
  end

  def euclidean_distance(point_1, point_2)
    sum_of_squares = 0.0
    point_1.each_with_index do |point_1_coord, ind|
      sum_of_squares += (point_1_coord - point_2[ind]) ** 2
    end
    Math.sqrt(sum_of_squares)
  end

  def array_subtraction(arr, subt)
    new_arr = arr.map {|a| a - subt }
    new_arr
  end

end

data_dict = {-1 => [[1,7],
                    [2,8],
                    [3,8]],
             1 => [[5,1],
                   [6,-1],
                   [7,3]]}

svm = SupportVectorMachine.new

svm.fit(data_dict)
p_ = svm.predict([6,10])
 p p_
