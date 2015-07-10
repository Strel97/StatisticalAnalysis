class CorrelationCalculator

  attr_reader :intervals, :measures, :quantities


  def initialize(metrics)
    @metrics = metrics.clone
    @intervals = Hash.new( Array.new(3, 0.0) )
    @measures = Hash.new( Array.new )
    @quantities = Hash.new
  end

  def calculate_max
    max_values = Array.new
    @metrics.each do |name, values|
      max_values << values.max
    end

    @intervals['max'] = max_values
  end

  def calculate_min
    min_values = Array.new
    @metrics.each do |name, values|
      min_values << values.min
    end

    @intervals['min'] = min_values
  end

  def calculate_interval_deviation
    deviations = Array.new
    8.times do |i|
      deviations << (@intervals['max'][i] - @intervals['min'][i]) / 5
    end

    @intervals['deviation'] = deviations
  end

  def calculate_intervals
    lower_bounds = @intervals['min']
    5.times do |i|
      upper_bounds = Array.new
      bound_id = 0

      @intervals['deviation'].each do |dev|
        upper_bounds << dev + lower_bounds[bound_id]
        bound_id += 1
      end

      @intervals["interval #{i + 1}"] = upper_bounds
      lower_bounds = upper_bounds
    end
  end

  def calculate_h
    h_values = Array.new
    @metrics.each do |name, values|
      h_values << (values.max - values.min) / Math.sqrt(22)
    end

    @measures['h'] = h_values
  end

  def calculate_mean
    mean_values = Array.new
    @metrics.each do |name, values|
      mean_values << values.inject { |sum, el| sum + el }.to_f / values.size
    end

    @measures['mean'] = mean_values
  end

  def calculate_variance
    variance_values = Array.new
    mean_id = 0

    @metrics.each do |name, values|
      sum = 0
      mean = @measures['mean'][mean_id]

      values.each do |val|
        sum += (mean - val) ** 2
      end

      variance_values << sum / values.length
      mean_id += 1
    end

    @measures['variance'] = variance_values
  end

  def calculate_standard_deviation
    deviation_values = Array.new
    @measures['variance'].each do |val|
      deviation_values << Math.sqrt(val)
    end

    @measures['standard deviation'] = deviation_values
  end

  def calculate_quantities

    intervals = Array.new
    interval_id = 0

    @metrics.each_pair do |name, values|
      quantity_values = Array.new(5, 0)
      intervals.clear

      5.times do |i|
        intervals << @intervals["interval #{i + 1}"][interval_id]
      end

      values.each do |val|
        5.times do |i|
          if val < intervals[i]
            quantity_values[i] += 1
            break
          elsif i == 5
            quantity_values[i] += 1
            break
          end
        end
      end

      interval_id += 1
      @quantities[name] = quantity_values
    end
  end

  def calculate_percentage
    project_cnt = @metrics[@metrics.first.first].size

    @quantities.each_pair do |name, values|
      percent_values = Array.new

      values.each do |val|
        percent_values << val * 100 / project_cnt
      end

      @quantities[name] = [values, percent_values]
    end
  end


  def make_intervals
    calculate_min
    calculate_max

    calculate_interval_deviation
    calculate_intervals

    @intervals
  end

  def make_measures
    calculate_h
    calculate_mean
    calculate_variance
    calculate_standard_deviation

    @measures
  end

  def make_quantities
    calculate_quantities
    calculate_percentage

    @quantities
  end
end