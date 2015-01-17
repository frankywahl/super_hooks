module SuperHooks
  class CLI
    attr_accessor :options

    def initialize
      @options = {}
    end

    def run(args = ARGV)
      if Git.repository?
        @options = Options.new.parse(args)
      else
        puts "#{BINARY_NAME} only works in GIT repositories"
        exit 1
      end
    end
  end

  private

  class Options
    attr_reader :options

    def initialize
    end

    def parse(args)
      define_options(args).parse!(args)
      options
    end

    private

    def define_options(args)
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename(__FILE__)} [options]"

        opts.separator "\nA tool to manage project, user, and global Git hooks for multiple git repositories.\n"
        opts.separator "\nOptions:"

        add_installation_options(args)
        add_uninstallation_options(args)
        add_global_installation_options(args)
        add_global_uninstallation_options(args)

        add_run_options
        add_list_options

        opts.seperator ''

        add_version_options(args)
        add_help_options(args)

        opts.separator "\nSupported hooks are #{SuperHooks::Hook::LIST.join(', ')}"
      end
    end

    def add_installation_options(opts)
      opts.on('--install', 'Replace existing hooks in this repository with a call to git hooks run [hook]',
              'Move old hooks directory to hooks.old') do
        SuperHooks::Installer.new.run
        exit
      end
    end

    def add_uninstallation_options(opts)
      opts.on('--uninstall', "Remove #{SuperHooks::BINARY_NAME}",
              'Removes hooks in this repository and rename `hooks.old` back to `hooks`') do
        SuperHooks::Installer.new.uninstall
        exit
      end
    end

    def add_global_installation_options(opts)
      opts.on('--install-global', 'Create a template .git directory. It will be used whenever ' \
              "a git repository is created or cloned that will remind the user to install #{SuperHooks::BINARY_NAME}",
              "This can't be done by default for security reasons") do
                SuperHooks::Installer::Global.new.run
                exit
              end
    end

    def add_global_uninstallation_options(opts)
      opts.on('--uninstall-global', 'Turn off the global .git directory template',
              "Those have reminders to install #{SuperHooks::BINARY_NAME}") do
        `git config --global --unset init.templatedir`.chomp
        exit
      end
    end

    def add_run_options(opts)
      opts.on('--run CMD', 'run hooks for CMD (such as pre-commit)') do |cmd|
        SuperHooks::Runner.new(cmd, ARGV).run
      end
    end

    def add_list_options(opts)
      opts.on('--list [option]', Array, 'list current hooks (for option)') do |_options|
        HooksPrinter.run
        exit
      end
    end

    def add_version_options(opts)
      opts.on('-v', '--version', "Current version of #{SuperHooks::BINARY_NAME}") do
        puts "#{SuperHooks::VERSION}"
        exit
      end
    end

    def add_help_options(opts)
      opts.on('-h', '--help', 'Print this help message') do
        puts opts
        exit
      end
    end
  end
end
