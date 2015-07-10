
# require './metric_loader'


class TrendlineEstimator

  attr_reader :linear_trend, :linear_trend_y


  def initialize( metrics )
    @metrics = metrics

    @linear_trend = Hash.new
    @linear_trend_y = Hash.new
    @linear_trend_x = Hash.new

    @logarithmic_trend = Hash.new
    @logarithmic_trend_y = Hash.new

    @exponential_trend = Hash.new
    @exponential_trend_y = Hash.new

  end

  def sort_metrics
    @metrics.sort_by {|metric, values| values.sort! }
  end

  def calculate_logarithmic
    @logarithmic_trend['LOC-CM'] = {
        :b => 110.16,
        :c => 872.27
    }

    @logarithmic_trend['LOC-WOC'] = {
        :b => -0.002,
        :c => 0.719
    }

    @logarithmic_trend['LOC-FDP'] = {
        :b => 4.9,
        :c => 33.67
    }

    @logarithmic_trend['NOM-CM'] = {
        :b => 110.16, # TODO
        :c => 872.27
    }

    @logarithmic_trend['NOM-WOC'] = {
        :b => -0.00013,
        :c => 0.696
    }

    @logarithmic_trend['NOM-FDP'] = {
        :b => 110.16, # TODO
        :c => 872.27
    }

    @logarithmic_trend['NOP-CM'] = {
        :b => -0.00013, # TODO
        :c => 0.696
    }

    @logarithmic_trend['NOP-WOC'] = {
        :b => 0.01,
        :c => 0.663
    }

    @logarithmic_trend['NOP-FDP'] = {
        :b => -0.00013, # TODO
        :c => 0.696
    }

    @logarithmic_trend['NOP-CM'] = {
        :b => -0.00013, # TODO
        :c => 0.696
    }

    @logarithmic_trend['NOP-CM'] = {
        :b => -0.00013, # TODO
        :c => 0.696
    }

    @logarithmic_trend['NOP-CM'] = {
        :b => -0.00013, # TODO
        :c => 0.696
    }
  end

  def calculate_polynomial

  end

  def calculate_coefficients
    (0...5).each do |direct_metric_id|
      (0...3).each do |indirect_metric_id|
        direct_metric_name = @metrics.keys[direct_metric_id]
        indirect_metric_name = @metrics.keys[indirect_metric_id + 5]

        # Calculating the slope of trendline
        # Step 1
        x_points =  @metrics[direct_metric_name]
        y_points =  @metrics[indirect_metric_name]
        n = x_points.size

        # Step 2
        sum = 0
        (0...n).each do |i|
          sum += x_points[i] * y_points[i]
        end
        a = n * sum

        # Step 3
        sum_x = 0
        sum_y = 0
        (0...n).each do |i|
          sum_x += x_points[i]
          sum_y += y_points[i]
        end
        b = sum_x * sum_y

        # Step 4
        sum_x = 0
        (0...n).each do |i|
          sum_x += x_points[i] ** 2
        end
        c = n * sum_x

        # Step 5
        sum_x = 0
        (0...n).each do |i|
          sum_x += x_points[i]
        end
        d = sum_x ** 2

        # Step 6
        slope = m = (a - b) / (c - d)


        # Calculate the y-intercept of the trendline
        # Step 1
        sum_y = 0
        (0...n).each do |i|
          sum_y += y_points[i]
        end
        e = sum_y

        # Step 2
        sum_x = 0
        (0...n).each do |i|
          sum_x += x_points[i]
        end
        f = slope * sum_x

        # Step 3
        y_intercept = b = (e - f) / n

        # Step 4
        @linear_trend["#{direct_metric_name}-#{indirect_metric_name}"] = {
            :slope => slope,
            :y_intercept => y_intercept
        }
      end
    end

    @linear_trend
  end

  def linear_trend_coord_calc
    (0...5).each do |direct_metric_id|
      (0...3).each do |indirect_metric_id|
        direct_metric_name = @metrics.keys[direct_metric_id]
        indirect_metric_name = @metrics.keys[indirect_metric_id + 5]
        trend_metric_name = "#{direct_metric_name}-#{indirect_metric_name}"

        points_y = Array.new
        @metrics[direct_metric_name].each do |val|
          points_y << @linear_trend[trend_metric_name][:slope] * val + @linear_trend[trend_metric_name][:y_intercept]
        end

        @linear_trend_y[trend_metric_name] = points_y
      end
    end

    @linear_trend_y
  end
end


# loader = MetricLoader.new
# loader.load_file('test/metrics')
# loader.load_transposed('test/transposed_metrics')
#
# puts ''
#
# line = TrendlineEstimator.new loader.transposed_metrics
# # line.calculate_exponential
# line.calculate_coefficients
#
# puts line.linear_trend