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
  end
end
