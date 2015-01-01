require 'spec_helper'

describe SuperHooks::Git do
  let(:git) { self.described_class }

  context "in a git repository" do
    describe "#repository" do
      it "returns the current repository path" do
        expect(git.repository?).to be true
        expect(git).to receive(:`).with("git rev-parse --show-toplevel 2>&1").and_return "/top/level/git/folder"
        expect(git.repository).to eql "/top/level/git/folder"
      end
    end
  end

  context "not in a repository" do
    before(:each) do
      expect(git).to receive(:`).with("git rev-parse --show-toplevel 2>&1").and_raise SuperHooks::Git::GitError
    end
    describe "#repository" do
      it "raises not a directory" do
        expect{git.repository}.to raise_error self.described_class::NotARepository
      end
    end

    describe "#repository?" do
      it "is false" do
        expect(git.repository?).to be false
      end
    end
  end
end
