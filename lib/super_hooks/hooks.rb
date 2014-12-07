module SuperHooks
  class Hooks
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

    attr_reader :filters

    def initialize(filters: nil)
      @filters = [*filters]
    end

    #
    # Returns an array of hooks installed: their path
    #
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

    def list_with_descriptions
      list.reduce({}) do |hash, file|
        hash[file] = `#{file} --about`
        hash
      end
    end

    private

    def global_hooks
      Dir[""]
    end

    def user_hooks
      Dir["#{ENV['HOME']}/.git_hooks/**/*"]
    end

    def project_hooks
      Dir["#{Git.repository}/.git/git_hooks/**/*"]
    end

  end
end
