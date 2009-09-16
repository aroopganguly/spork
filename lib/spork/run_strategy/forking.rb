class Spork::RunStrategy::Forking < Spork::RunStrategy
  def self.available?
    Kernel.respond_to?(:fork)
  end

  def run(argv, stderr, stdout)
    abort if running?

    @child = ::Spork::Forker.new do
      $stdout, $stderr = stdout, stderr
      load test_framework.helper_file
      Spork.exec_each_run
      test_framework.run_tests(argv, stderr, stdout)
    end
    @child.result
  end

  def abort
    @child && @child.abort
  end

  def preload
    require test_framework.entry_point
    test_framework.preload
  end

  def running?
    @child && @child.running?
  end

end