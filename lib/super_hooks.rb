require 'extensions/string'
require 'super_hooks/version'
require 'super_hooks/hooks'
require 'super_hooks/installer'
require 'super_hooks/git'

require 'pry'

module SuperHooks
  ROOT = Pathname.new(File.dirname(__FILE__) + "/../").expand_path
end
