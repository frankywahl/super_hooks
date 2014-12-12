module SuperHooks
  class IOInterceptor

    attr_reader :input, :output, :error

    attr_reader :old_output, :old_error

    def initialize
      @old_output  = $stdout
      @old_error   = $stderr
    end

    def puts(string)
      output << "#{string}"
    end

    def release
      begin
        [output, error]
      ensure
        $stdout = old_output
        $stderr = old_error

      end
    end
  end
end

module ThreadOut

  ##
  # Writes to Thread.current[:stdout] instead of STDOUT if the thread local is
  # set.

  def self.write(stuff)
    if Thread.current[:stdout] then
      Thread.current[:stdout].write stuff
    else
      STDOUT.write stuff
    end
  end

end

$stdout = ThreadOut
