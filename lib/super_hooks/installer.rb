module SuperHooks
  # Class responsible for installing and uninstalling the SuperHooks
  class Installer
    class AlreadyInstalledError < StandardError; end # :nodoc:

    # A handler to deal with global hooks
    class Global
      # Execute the installer
      #
      # This will create the files needed for SuperHooks to work
      def run
        create_git_global_template_folder
        Git.command "config --global init.templatedir #{template_directory}"
      end

      private

      def template_directory
        ENV["HOME"] + "/.git_global_templates"
      end

      def create_git_global_template_folder
        return if File.exist? template_directory
        FileUtils.mkdir_p(template_directory + "/hooks/")
        Hook::LIST.each do |hook|
          file_name = File.join(template_directory, "hooks", hook)
          File.open(file_name, "w", 0o755) do |f|
            f.write(template_file)
          end
        end
      end

      def template_file
        @template_file ||= begin
          orig_file = File.read(ROOT.join("templates", "global_install_hook.erb"))
          ERB.new(orig_file).result(binding)
        end
      end
    end

    # Run the installer
    #
    # This will create a copy of the .git/hooks folder to .git/hooks.old
    # And create new files for future hooks to user SuperHooks
    #
    # Examples
    #
    #   run
    #   # => true
    #
    def run
      if already_installed?
        $stderr.puts "SuperHooks already installed"
        exit 1
      end
      copy_to_backup_folder
      create_new_files
    end

    # Uninstall GitHooks
    #
    # This will do the following
    #
    # * remove the projects .git/git_hooks folder
    # * rename the .git/hooks.old/ folder to .git/hooks/
    #
    def uninstall
      unless already_installed?
        $stderr.puts "SuperHooks is not installed"
        exit 1
      end

      remove_hooks_folder
      restore_old_folder
    end
    alias_method :remove, :uninstall

    private

    def already_installed?
      ::File.exist?(hook_folder + ".old")
    end

    def copy_to_backup_folder
      FileUtils.mv(hook_folder, hook_folder + ".old")
    end

    def hook_folder
      File.join(Git.repository, ".git", "hooks")
    end

    def create_new_files
      Dir.mkdir(hook_folder)

      Hook::LIST.each do |hook|
        file = File.join(Git.repository, ".git", "hooks", hook)
        FileUtils.cp(ROOT.join("templates", "hook"), file)
      end
    end

    def remove_hooks_folder
      FileUtils.rm_rf(hook_folder)
    end

    def restore_old_folder
      FileUtils.mv(hook_folder + ".old", hook_folder)
    end
  end
end
