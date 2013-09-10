module TSpec
  class TestRun
    attr_reader :failures, :tspec
    def initialize options={}
      if use_color?
        @pass_output = "\e[32m.\e[0m"
        @fail_output = "\e[31mF\e[0m"
      else
        @pass_output = '.'
        @fail_output = 'F'
      end
      @failures = []
      @tspec = options.fetch(:tspec) { TSpec }
      @output = options.fetch(:output) { STDOUT }
    end

    def run!
      start
      examples.each { |example| run_example example }
      finish
    end

    def run_with_threads! thread_count=8
      example_queue = Queue.new
      examples.each { |example| example_queue << example }

      # Count completed examples per thread
      completed_examples = Array.new(thread_count) { 0 }

      start

      threads = thread_count.times.map do |i|
        Thread.new do
          loop do
            example = example_queue.shift
            run_example example
            completed_examples[i] += 1
          end
        end
      end

      Thread.pass until completed_examples.reduce(0, :+) == examples.count

      finish
    end

    def run_example example
      example.call
      @output.print @pass_output
    rescue => exception
      failures << Failure.new(example, exception)
      @output.print @fail_output
    end

    def start
      @start ||= Time.now
    end

    def finish
      @finish ||= Time.now
    end

    def runtime
      # examples.map(&:duration).reduce(0, :+)
      (finish - start) * 1000
    end

    def examples
      @examples ||= tspec.descriptions.flat_map(&:examples).shuffle
    end

    def report
      if examples.any?
        count = examples.count
        @output.puts
        @output.puts
        @output.puts "%d specs finished in %.3fms (%.3fms/spec, %.3f specs/sec)" % [
          count,
          runtime,
          runtime / count,
          count / (runtime / 1000)
        ]
        failures.each do |failure|
          @output.puts
          @output.puts "Failed: #{failure.example.title}"
          @output.puts "  -- #{failure.message}"
          @output.puts failure.exception.backtrace
        end
      else
        @output.puts "No examples."
      end
    end

    def use_color?
      %w(t true 1).include? ENV['TSPEC_COLOR'].to_s.downcase
    end
  end
end
