
require '../correlation_calculator'
require '../metric_loader'


class CorrelationCalculatorT
  def initialize
    @loader = MetricLoader.new
    @loader.load_file("metrics")
    @loader.load_transposed("transposed_metrics")

    @metrics = @loader.metrics

    @correlation = CorrelationCalculator.new(@loader.transposed_metrics)
    @intervals = @correlation.make_intervals
    @measures = @correlation.make_measures
  end

  def test_make_quantities
    @correlation.make_quantities
  end
end


test = CorrelationCalculatorT.new
puts test.test_make_quantities