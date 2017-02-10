require 'securerandom'

def create_dataset(hm, variance, step=2, correlation=false)
  val = 1
  ys = []
  (0..hm).to_a.each do |i|
    y = val + SecureRandom.random_number(-variance..variance)
    ys << y.to_f
    if correlation && correlation == 'pos'
      val += step
    elsif correlation && correlation =='neg'
      val -= step
    end
  end
  xs = (0...ys.length).to_a.map { |i| i.to_f }
  return [xs, ys]
end


def best_fit_slope_and_intercept(xs, ys)
  top_m = ( (mean(xs) * mean(ys)) - mean(arr_multiply(xs, ys)) )
  bottom_m = (mean(xs)**2 - mean(arr_squared(xs)))
  m = top_m / bottom_m
  b = mean(ys) - m*(mean(xs))
  [m, b]
end

def squared_error(ys_orig, ys_line)
  squared_items = arr_squared(arr_subtract(ys_line, ys_orig))
  return squared_items.inject(:+)
end

def coefficient_of_determination(ys_orig, ys_line)
  ys_mean = mean(ys_orig)
  y_mean_line = ys_orig.map { |a| ys_mean }
  squared_error_regr = squared_error(ys_orig, ys_line)
  squared_error_y_mean = squared_error(ys_orig, y_mean_line)
  return 1 - (squared_error_regr / squared_error_y_mean)
end

def mean(arr)
  arr.inject(:+) / arr.length
end

def arr_multiply(arr_1, arr_2)
  p arr_1.length
  p arr_2.length
  products = arr_1.map.with_index { |a, i| a * arr_2[i] }
  products
end

def arr_subtract(arr_1, arr_2)
  results = arr_1.map.with_index { |a, i| a - arr_2[i] }
  results
end

def arr_squared(arr)
  arr.map {|e| e**2 }
end

xs, ys = create_dataset(40, 40, 2, false)

m,b = best_fit_slope_and_intercept(xs, ys)

regression_line = xs.map {|x| (m*x)+b }

predict_x = 8
predict_y = (m*predict_x)+b

r_squared = coefficient_of_determination(ys, regression_line)
p r_squared
