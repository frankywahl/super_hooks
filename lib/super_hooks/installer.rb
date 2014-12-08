module SuperHooks
  # Class responsible for installing and uninstalling the SuperHooks
  class Installer

    class AlreadyInstalledError < StandardError; end # :nodoc:


    # A handler to deal with global hooks
    class Global

      # Execute the installer
      def run
        unless File.exists? template
          FileUtils.mkdir_p(template + "/hooks/")
          Hooks.list.each do |hook|
            file = "#{template}/hooks/#{hook}"
            File.open(file, 'w', 0755) do |f|
              f.puts '#!/usr/bin/env bash'
              f.puts <<-EOF
                echo "git hooks not installed in this repository.  Run \\`git-hooks --install\\` to install it or \\`git-hooks -h\\` for more information."
              EOF
            end
          end

        end

        Git.command "config --global init.templatedir #{template}"
      end

      private
      def template
        ENV["HOME"] + "/.git_global_templates"
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
      ::File.exists?(hook_folder + ".old")
    end

    def copy_to_backup_folder
      FileUtils.mv(hook_folder, hook_folder + ".old")
    end

    def hook_folder
      Git.repository + "/.git/hooks"
    end

    def create_new_files
      Dir.mkdir(hook_folder)

      Hooks.list.each do |hook|
        File.open(Git.repository + "/.git/hooks/#{hook}", 'w', 0755) do |f|
          f.puts '#!/usr/bin/env ruby'
          f.puts 'exec("super_hooks --run #{File.basename(__FILE__)} #{ARGV}")'
        end
      end
    end

    def remove_hooks_folder
      FileUtils.rm_rf(hook_folder + "/")
    end

    def restore_old_folder
      FileUtils.mv(hook_folder + ".old/", hook_folder)
    end

  end
end
