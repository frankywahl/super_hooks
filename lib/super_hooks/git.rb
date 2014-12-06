module SuperHooks
  module Git

    class NotARepository < StandardError; end
    class GitError < StandardError; end

    class << self

      def repository
        begin
          git "rev-parse --show-toplevel"
        rescue GitError
          raise NotARepository
        end
      end

      def repository?
        begin
          repository
          true
        rescue NotARepository
          false
        end
      end

      private
      def git(cmd)
        output = `git #{cmd} 2>&1`.chomp
        raise GitError, "`git #{cmd}` failed" unless $?.success?
        output
      end
    end
  end
end
