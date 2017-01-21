require "simplecov"
require "simplecov-console"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 SimpleCov::Formatter::Console
                                                               ])
SimpleCov.start do
  minimum_coverage 100
  add_filter "spec"
end
require "rspec"
require "super_hooks"

Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }
require "pry"

RSpec.configure do |c|
  c.include Helpers

  c.before(:example) do
    @repository = ::Helpers::GitRepository.new
    stub_const("ENV", ENV.to_hash.merge("HOME" => "/NON/EXISTING/DIRECTORY"))
  end

  c.after(:example) do
    @repository.remove
  end
end
