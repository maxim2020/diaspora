module ResqueJobLogging
  def around_perform_log_job(*args)
    log_string = "event=resque_job job=#{self} "
    error = nil
    time = Benchmark.realtime{
      begin
        yield
      rescue Exception => e
        error = e
      end
    }*1000
    if error
      log_string += "status=error error=\"#{error}\" "
    else
      log_string += "status=complete "
    end
    log_string += "ms=#{time} "
    arg_count = 1
    args.each{|arg| log_string += "arg#{arg_count}=\"#{arg[0..30]}\" "}

    Rails.logger.info(log_string)
    raise error if error
  end
end
