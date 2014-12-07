require 'spec_helper'

describe SuperHooks::Git do
  let(:git) { self.described_class }

  context "in a git repository" do
    describe "#repository" do
      it "returns the current repository path" do
        expect(git.repository?).to be true
        expect(git.repository).to eql @repository.path
      end
    end
  end

  context "not in a repository" do
    describe "#repository" do
      it "raises not a directory" do
        repository = ::Helpers::EmptyRepository.new
        expect{git.repository}.to raise_error self.described_class::NotARepository
        expect(git.repository?).to be false
        repository.remove
      end
    end
  end
end
