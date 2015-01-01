# Add the directory containing this file to the start of the load path if it
# isn't there already.
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'core_ext/string'
require 'version'
require 'hook'
require 'installer'
require 'git'
require 'runner'

require 'pathname'
require 'fileutils'
require 'erb'

# A module to interact with git hooks
#
# It is knows if hooks are installed or not
module SuperHooks

  # The binary name
  # Used for covenience when creating the scripts
  BINARY_NAME = "super_hooks"

  # The root pathname
  ROOT = Pathname.new(File.dirname(__FILE__) + "/../").expand_path

  # Allows to look if super_hooks is installed
  #
  # Example:
  #
  #   installed?
  #   #=> true
  #
  # Returns a boolean
  def self.installed?
    return false unless Git.repository?
    hooks_folder = File.join(Git.current_repository, ".git", "hooks.old", "")
    File.exist?(hooks_folder)
  end


end
