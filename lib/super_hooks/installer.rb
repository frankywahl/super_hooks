module SuperHooks
  class Installer

    class NotAGitRepositoryError < StandardError; end

    def initialize
    end

    def run
      raise NotAGitRepositoryError
    end

    private
    def create_hooks_files
    end

    def current_folder
      `git rev-parse --show-toplevel`
    end
  end
end
