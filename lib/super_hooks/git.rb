module SuperHooks
  module Git

    class NotARepository < StandardError; end # :nodoc:

    class GitError < StandardError; end # :nodoc:

    class << self

      # Returns the current repository if root path
      #
      # Examples
      #
      #   repository
      #   # => /home/franky/my_git_folder/
      #
      # Returns a string of the repository name
      # Raises NotARepository if we're not in a git repository
      #
      alias_method :current_repository,
      def repository
        begin
          git "rev-parse --show-toplevel"
        rescue GitError
          raise NotARepository
        end
      end

      # Are we in a git repository
      #
      # Examples
      #
      #   repository?
      #   # => true
      #
      # Returns a boolean value
      # Raises NotARepository if we're not in a git repository
      #
      def repository?
        begin
          repository
          true
        rescue NotARepository
          false
        end
      end

      private
      # Run a git command
      #
      # Examples
      #
      #   git "status -s"
      #   # => "M lib/super_hooks/file.rb\nM lib/super_hooks.file2.rb"
      #
      # Raises GitError if the command fails
      #
      def git(cmd)
        output = `git #{cmd} 2>&1`.chomp
        raise GitError, "`git #{cmd}` failed" unless $?.success?
        output
      end
    end
  end
end
