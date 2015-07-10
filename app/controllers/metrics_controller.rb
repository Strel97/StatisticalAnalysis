
require 'metric_loader'
require 'correlation_calculator'
require 'rank_calculator'
require 'trendline_estimator'


class MetricsController < ApplicationController

  attr_reader :metrics, :transposed_metrics, :intervals, :measures, :quantities, :ranks, :rank_difference, :sum, :t, :linear_trend


  def index
    loader = MetricLoader.new
    @metrics = loader.load_file("#{Rails.root}/public/data/metrics")
    @transposed_metrics = loader.load_transposed("#{Rails.root}/public/data/transposed_metrics")

    correlation = CorrelationCalculator.new(loader.transposed_metrics)
    @intervals = correlation.make_intervals
    @measures = correlation.make_measures
    @quantities = correlation.make_quantities

    calculator = RankCalculator.new(loader.transposed_metrics)
    @ranks = calculator.calc_ranks
    @rank_difference = calculator.calc_rank_difference
    @sum = calculator.calc_sum
    @t = calculator.calc_t

    # Костыль!!!
    @transposed_metrics = loader.load_transposed("#{Rails.root}/public/data/transposed_metrics")

    trendline = TrendlineEstimator.new(@transposed_metrics.clone)
    @linear_trend = trendline.calculate_coefficients
    @linear_trend_y = trendline.linear_trend_coord_calc

    render partial: 'calculations'
  end
end