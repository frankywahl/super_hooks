require 'spec_helper'

describe SuperHooks::Runner do
  let(:runner) { self.described_class.new("commit-msg", "super_argument") }

  let(:hooks) { %w(/home /bar) }

  let(:bad_hook) {
    file = "#{@repository.path}/.git/git_hooks/commit-msg/foo"
    Helpers::BadHook.new(file).path
  }

  describe "#run" do

    it "runs once for each hook" do
      expect(SuperHooks::Hooks).to receive(:new).with(filters: "commit-msg").and_return(double("Hooks", list: hooks))
      expect(runner).to receive(:`).with("/home super_argument").and_return(nil)
      expect(runner).to receive(:`).with("/bar super_argument").and_return(nil)
      runner.run rescue SystemExit
    end

    it "returns a bad error code if one script fails" do
      expect($stderr).to receive(:puts) do |args|
        expect(args).to include "#{bad_hook} did not exit with a successfull message"
      end
      expect(SuperHooks::Hooks).to receive(:new).with(filters: "commit-msg").and_return(double("Hooks", list: [bad_hook]))
      begin
        runner.run
      rescue SystemExit => e
        expect(e.status).to eql 1
      end
    end

  end
end