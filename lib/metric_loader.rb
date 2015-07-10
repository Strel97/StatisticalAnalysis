# #
# Loads Metrics
# #
class MetricLoader

  attr_reader :metrics, :transposed_metrics


  def initialize
    @metrics = Hash.new
    @transposed_metrics = Hash.new
  end

  def load_file(file)
    File.open(file).each do |line|
      project_line = line.split('_')

      project = project_line[0]
      values = project_line[1].split('::')

      @metrics[project] = values.map(&:to_f)
    end

    @metrics
  end

  def load_transposed(file)
    metric_names = %w(LOC NOM NOP NDD HIT CM WOC FDP)
    metric_id = 0

    File.open(file).each do |line|
      values = line.split('::')

      @transposed_metrics[metric_names[metric_id]] = values.map(&:to_f)
      metric_id += 1
    end

    @transposed_metrics
  end

  def print_metrics
    @metrics.each { |name, value| puts "#{name} => #{value}"}
  end

  def print_transposed
    @transposed_metrics.each { |name, value| puts "#{name} => #{value}"}
  end
end

# loader = MetricLoader.new
# loader.load_transposed 'test/transposed_metrics'
# puts loader.transposed_metrics