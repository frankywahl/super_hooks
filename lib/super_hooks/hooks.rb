module SuperHooks
  class Hooks

    # An array of existing git hooks
    #
    # Examples
    #
    #   # list
    #   # => ["commit-msg", "pre-rebase", ...]
    #
    # Returns a list of known hooks
    #
    def self.list
      %w(
        applypatch-msg
        commit-msg
        post-applypatch
        post-checkout
        post-commit
        post-merge
        post-receive
        pre-applypatch
        pre-auto-gc
        pre-commit
        prepare-commit-msg
        pre-rebase
        pre-receive
        update
        pre-push
      )
    end


    # An array of filters we want to apply
    #
    # Example of such include ["commit-msg", "post-merge"]
    #
    attr_reader :filters


    #
    # :args: filters
    #
    def initialize(filters: nil)
      @filters = [*filters]
    end

    #
    # Returns an array of hooks installed
    #
    # Examples
    #
    #   # list
    #   # => ["/home/franky/.git_hooks/commit-msg/sign_off.rb"]
    #
    # Returns an array of file paths that match corresponding hooks
    #
    def list
      list = user_hooks + global_hooks + project_hooks
      list.select!{|f| File.file? f}
      return list if filters.empty?
      filters.each do |filter|
        list.select!{|f| f.include? filter.to_s }
      end
      list
    end

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
    def list_with_descriptions
      list.reduce({}) do |hash, file|
        hash[file] = `#{file} --about`
        hash
      end
    end

    private
    def global_hooks
      dir = `git config hooks.global`.chomp
      return [] if dir.empty?
      Dir["#{dir}**/*"]
    end

    def user_hooks
      Dir["#{ENV['HOME']}/.git_hooks/**/*"]
    end

    def project_hooks
      Dir["#{Git.repository}/.git/git_hooks/**/*"]
    end

  end
end
