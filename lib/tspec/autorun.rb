require 'tspec/test_run'

at_exit do
  test_run = TSpec::TestRun.new
  if ENV.has_key? 'TSPEC_THREADS'
    thread_count = ENV.fetch('TSPEC_THREADS').to_i
    test_run.run_with_threads! thread_count
  else
    test_run.run!
  end

  test_run.report
end
