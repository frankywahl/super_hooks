module SuperHooks
  # Interface with the list of hooks available
  class Hook

    # An array of existing git hooks
    LIST = %w( applypatch-msg commit-msg post-applypatch post-checkout post-commit post-merge post-receive pre-applypatch pre-auto-gc pre-commit prepare-commit-msg pre-rebase pre-receive update pre-push )

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
        hooks = level.map{|l| send("#{l}_hooks")}

        hooks.flatten!

        hooks.select!{|f| is_a_hook? f}

        hooks.select!{|hook| hook =~ /#{name}/} unless name.nil?

        hooks.select!{|hook| [*kind].any?{ |foo| hook =~ /#{foo}/ }}

        hooks.map{|hook| new(hook) }
      end
      alias_method :all, :where

      private
      def user_hooks
        Dir["#{ENV['HOME']}/.git_hooks/**/*"]
      end

      def project_hooks
        Dir["#{Git.repository}/.git/git_hooks/**/*"]
      end

      def global_hooks
        begin
          dir = Git.command "config hooks.global"
          Dir["#{dir}/**/*"]
        rescue SuperHooks::Git::GitError
        []
        end
      end

      def is_a_hook?(path)
        (File.file? path) && (File.stat(path).executable?)
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
    def execute!(arguments = "")
      system("#{path} #{arguments}", out: $stdout, err: $stderr)
    end
    alias_method :run, :execute!

    # A hash containing a file_name => description
    #
    # Example
    #
    #   # list_with_descriptions
    #   # => {
    #   #     "/home/franky/.git_hooks/commit-msg/sign_off.rb" => "A signoff commit msg",
    #   #     "/home/franky/.git_hooks/pre-commit/whitespace.rb" => "Checks no unecessary whitespace",
    #   #    }
    #
    # It gets the description of the file by running the file name with the --about flag
    #
    def description
      `#{path} --about`.chomp
    end

  end
end
