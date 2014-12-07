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

    def list
      list = user_hooks + global_hooks + project_hooks
      list.select{|f| File.file? f}
    end

    private

    def global_hooks
      Dir[""]
    end

    def user_hooks
      Dir["#{ENV['HOME']}/.git_hooks/**/*"]
    end

    def project_hooks
      Dir["#{SuperHooks::Git.repository}/.git_hooks/**/*"]
    end

  end
end
