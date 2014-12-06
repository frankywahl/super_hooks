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
end
