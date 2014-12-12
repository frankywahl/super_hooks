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
      @hooks = Hook.where(kind: [hook])
      @arguments = arguments
    end

    # Run all the associated hooks
    #
    # Exit the program with a bad status if any of the hooks fail
    #
    def run(parallel: true)
      failed_hooks = []

      interceptors = []


      if parallel
        threads = []
        hooks.each do |hook|
          s = StringIO.new
          interceptors << s
          threads << Thread.new{
            Thread.current[:stoud] = s
            hook.execute!
        }
        end
        threads.each {|t| t.join}
        binding.pry

      end


      #hooks.each do |hook|
      #  failed_hooks << hook unless hook.execute!(arguments)
      #end

      unless failed_hooks.empty?
        $stderr.puts "Hooks #{failed_hooks.map(&:path).join(', ')} failed to exit successfully"
        exit 1
      end
    end
  end
end
