module SuperHooks
  # Class responsible for running the hooks and reporting on status
  class Runner

    # the hooks one would like to run
    attr_reader :hooks

    # arguments passed by git when running a hook
    attr_reader :arguments

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
      failed_hooks = []
      hooks.each do |hook|
        `#{hook} #{arguments}`
        unless $?.success?
          failed_hooks << hook #"#{hook} did not exit with a successfull message"
        end
      end

      unless failed_hooks.empty?
        $stderr.puts "Hooks #{failed_hooks.join(", ")} failed to exit successfully"
        exit 1
      end

    end

  end
end
