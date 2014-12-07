require 'rspec'
require 'super_hooks'
Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }
require 'pry'

RSpec.configure do |c|
  c.include Helpers

  c.before(:example) do
    @repository = ::Helpers::GitRepository.new

    stub_const('ENV', ENV.to_hash.merge({"HOME" => "/NON/EXISTING/DIRECTORY"}))
  end

  c.after(:example) do
    @repository.remove
  end
end
