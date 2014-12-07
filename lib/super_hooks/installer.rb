module SuperHooks
  class Installer

    class AlreadyInstalledError < StandardError; end # :nodoc:


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

  end
end
