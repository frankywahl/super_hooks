require 'spec_helper'


describe SuperHooks::Hooks do
  describe "#list" do
    it "lists the set of hooks" do
      list = [
        "applypatch-msg",
        "commit-msg",
        "post-applypatch",
        "post-checkout",
        "post-commit",
        "post-merge",
        "post-receive",
        "pre-applypatch",
        "pre-auto-gc",
        "pre-commit",
        "prepare-commit-msg",
        "pre-rebase",
        "pre-receive",
        "update",
        "pre-push"
      ]
      expect(self.described_class.list).to eql list
    end
  end

  describe "installed hooks" do

    let(:hooks) { self.described_class.new }

    it "includes project hooks" do
      file = "#{@repository.path}/.git_hooks/commit-msg/foo"
      dirname = File.dirname(file)

      FileUtils.mkdir_p(dirname) unless File.directory? dirname

      File.new(file, 'w') do |f|
        f.puts "ok"
      end
      expect(hooks.list).to match_array(file)
    end
  end
end
