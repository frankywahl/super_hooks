module SuperHooks
  class Runner

    attr_reader :hooks, :arguments


    def initialize(hook, arguments)
      @hooks = Hooks.new(filters: hook).list
      @arguments = arguments
    end

    def run
      hooks.each do |hook|
        `#{hook} #{arguments}`
        unless $?.success?
          puts "#{hook} did not exit with a successfull message"
          exit 1
        end
      end
    end

  end
end
