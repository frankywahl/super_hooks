module SuperHooks
  # Class responsible for running the hooks and reporting on status
  class Runner

    attr_reader :hooks, :arguments

    # Prepare for a new commit runner check
    #
    # * hook: the hook name wer're about to run
    # * arguments: the arguments past to the hook
    #
    def initialize(hook, arguments)
      @hooks = Hooks.new(filters: hook).list
      @arguments = arguments
    end


    # Run all the associated hooks
    #
    # Exit the program with a bad status if any of the hooks fail
    #
    def run
      hooks.each do |hook|
        `#{hook} #{arguments}`
        unless $?.success?
          $stderr.puts "#{hook} did not exit with a successfull message"
          exit 1
        end
      end
    end

  end
end
