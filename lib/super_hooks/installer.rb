module SuperHooks
  class Installer

    class AlreadyInstalledError < StandardError; end

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
      SuperHooks::Git.repository + "/.git/hooks"
    end

    def create_new_files
      Dir.mkdir(hook_folder)

      SuperHooks::Hooks.list.each do |hook|
        File.open(SuperHooks::Git.repository + "/.git/hooks/#{hook}", 'w', 0755) do |f|
          f.puts '#!/usr/bin/env ruby'
          f.puts 'exec("super_hooks --run #{File.basename(__FILE__)} #{ARGV}")'
        end
      end
    end

  end
end
