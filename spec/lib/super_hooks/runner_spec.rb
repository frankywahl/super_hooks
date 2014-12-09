require 'spec_helper'

describe SuperHooks::Runner do

  let(:hook) { double("hook") }

  let(:runner) { self.described_class.new("commit-msg", "super_argument") }

  let(:bad_hook) {
    file = "#{@repository.path}/.git/git_hooks/commit-msg/foo"
    Helpers::BadHook.new(file).path
  }

  before :each do
    allow(SuperHooks::Hook).to receive(:where).and_return([hook])
  end

  describe "#initialize" do
    it "sets the hooks" do
      expect(runner.hooks).to eql([hook])
    end

    it "set the arguments that where sent" do
      expect(runner.arguments).to eql("super_argument")
    end
  end

  describe "#run" do

    it "runs each hook" do
      expect(hook).to receive(:execute!).with("super_argument").and_return(true)
      runner.run
    end

    it "returns a bad error code if one script fails" do
      expect(hook).to receive(:execute!).with("super_argument").and_return(false)
      expect(hook).to receive(:path).and_return("ok")
      expect($stderr).to receive(:puts) do |args|
        expect(args).to include "Hooks ok failed to exit successfully"
      end

      begin
        runner.run
      rescue SystemExit => e
        expect(e.status).to eql 1
      end
    end

  end
end
