module SuperHooks
  module Presenters
    class HooksPresenter
      def self.run
        puts description
      end

      def self.description
        string = ''
        [:project, :user, :global].each do |level|
          string << "\n#{level.capitalize} hooks:\n------------------"
          SuperHooks::Hook.where(level: level).each do |hook|
            string << SuperHooks::HokPresenter.new(hook, max_length: 80).print
          end
          string << "\n"
        end
        string
      end
    end
  end
end
