module SuperHooks
  module Presenters
    class HookPresenter
      attr_reader :hook
      attr_reader :max_length

      def initialize(hook, max_length: 80)
        @hook = hook
        @max_length = max_length
      end

      def print
        "#{text}\n    ~> #{description}\n"
      end

      private

      def text
        hook.path.truncate_at_start(max_length, omission: '...')
      end

      def description
        hook.description.truncate(max_length)
      end
    end
  end
end
