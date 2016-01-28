module SuperHooks
  # Interface with the list of hooks available
  class Hook
    # An array of existing git hooks
    LIST = %w( applypatch-msg commit-msg post-applypatch post-checkout post-commit post-merge post-receive
               pre-applypatch pre-auto-gc pre-commit prepare-commit-msg pre-rebase pre-receive update pre-push ).freeze

    class << self
      # Find a list of hooks by applying the levels to them
      #
      # *name: the name of the path (can be partial)
      # *kind: the type of hook. eg: pre-commit
      # *level: the folder to search for hooks: [:user, :project, :global]
      #
      # Example
      #
      #   # where(name: "rake", kind: ["pre-rebase", "pre-commit"], level: [:user])
      #   #
      #   # => [#<SuperHooks::Hook:0x007ffa32030758 @path="/home/franky/.git/git_hooks/pre-rebase/rake"]
      #
      # Returns an array of Hooks
      #
      def where(name: nil, kind: LIST, level: [:user, :project, :global])
        hooks = [*level].map { |l| send("#{l}_hooks") }

        hooks.flatten!

        hooks.select! { |f| a_hook? f }

        hooks.select! { |hook| hook =~ /#{name}/ } unless name.nil?

        hooks.select! { |hook| [*kind].any? { |foo| hook =~ /#{foo}/ } }

        hooks.map { |hook| new(hook) }
      end
      alias_method :all, :where

      private

      def user_hooks
        path = File.join(ENV['HOME'], '.git_hooks', '**', '*')
        Dir[path]
      end

      def project_hooks
        path = File.join(Git.repository, '.git', 'git_hooks', '**', '*')
        Dir[path]
      end

      def global_hooks
        dirs = Git.command('config hooks.global').split(',')
        dirs.map do |dir|
          path = File.join(dir, '**', '*')
          Dir[path]
        end
      rescue SuperHooks::Git::GitError
        []
      end

      def a_hook?(path)
        (File.file? path) && File.stat(path).executable?
      end
    end

    # The path to the executable
    attr_reader :path

    # The initializer
    #
    # *path: the path to the executable
    #
    def initialize(path)
      @path = path
    end

    # Acatully execute the hook
    #
    # *arguments: the arguments passed from git
    #
    # Example
    #
    #   execute("GIT_HEAD_MSG")
    #   # => true
    #
    #  Returns a boolean indicating if this was a successfull run
    def execute!(arguments = '')
      system("#{path} #{arguments}", out: $stdout, err: $stderr)
    end
    alias_method :run, :execute!

    # Get a short description of the hook
    #
    # It gets the description of the file by running the file name with the --about flag
    #
    # Example
    #
    #   # description
    #   #   => "A signoff commit msg",
    #
    #  Returns a string
    def description
      `#{path} --about`.chomp
    end
  end
end
