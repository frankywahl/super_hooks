# Add the directory containing this file to the start of the load path if it
# isn't there already.
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'super_hooks/core_ext/string'
require 'super_hooks/version'
require 'super_hooks/hooks'
require 'super_hooks/installer'
require 'super_hooks/git'
require 'super_hooks/runner'

require 'pry'

module SuperHooks
  ROOT = Pathname.new(File.dirname(__FILE__) + "/../").expand_path

  class << self

    def installed?
      `ls .git/hooks.old/ 2>/dev/null`
      $?.success?
    end

  end
end
