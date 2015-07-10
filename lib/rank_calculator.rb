class RankCalculator

  attr_reader :ranks, :rank_difference, :sum, :t


  def initialize(metrics)
    @metrics = metrics.clone

    @ranks = Hash.new
    @rank_difference = Hash.new
    @sum = Hash.new
    @t = Hash.new
  end

  def calc_ranks
    @metrics.each do |key, value|
      rank_val = value.length
      ranks = Array.new

      value.each do
        current_max_id = value.index(value.max)

        ranks[current_max_id] = rank_val
        value[current_max_id] = -1

        rank_val -= 1
      end

      @ranks[key] = ranks
    end

    @ranks
  end

  def calc_rank_difference
    (0...5).each do |direct_metric_id|
      (0...3).each do |indirect_metric_id|

        direct_metric_name = @ranks.keys[direct_metric_id]
        indirect_metric_name = @ranks.keys[indirect_metric_id + 5]

        # Finding squared difference between direct
        # and indirect metrics
        difference = Array.new
        (0...@ranks[direct_metric_name].length).each do |id|
          difference << (@ranks[direct_metric_name][id] - @ranks[indirect_metric_name][id]) ** 2
        end

        @rank_difference["#{direct_metric_name}-#{indirect_metric_name}"] = difference
      end
    end

    @rank_difference
  end

  def calc_sum
    @rank_difference.each do |key, values|
      @sum[key] = values.inject { |sum, val| sum + val.to_f }
    end

    @sum
  end

  def calc_t
    @sum.each do |key, value|
      @t[key] = 1.0 - (6.0 / (22.0 * ((22.0 * 22.0) - 1.0))) * value
    end

    @t
  end

  def get_metrics
    @metrics
  end


  def print_ranks
    @ranks.each { |key, value| puts "#{key} => #{value}" }
    puts ''
    @rank_difference.each { |key, value| puts "#{key} => #{value}" }
    puts ''
    @sum.each { |key, value| puts "#{key} => #{value}" }
    puts ''
    @t.each { |key, value| puts "#{key} => #{value}" }
  end
end

# loader = MetricLoader.new
# loader.load_file('test/metrics')
# loader.load_transposed('test/transposed_metrics')
# # loader.print_metrics
#
# puts ''
#
# calculator = RankCalculator.new(loader.transposed_metrics)
# calculator.calc_ranks
# calculator.calc_rank_difference
# calculator.calc_sum
# calculator.calc_t
# calculator.print_ranks
#
# puts calculator.metrics