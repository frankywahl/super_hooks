require 'spec_helper'
require 'super_hooks'

describe SuperHooks do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  describe "#installed?" do

    context "in a git repository" do
      context "with a hooks.old folder" do
        it "returns true" do
          `mkdir -p .git/hooks.old/`
          expect(self.described_class.installed?).to be true
        end
      end

      context "without a hooks.old folder" do
        it "returns false" do
          expect(self.described_class.installed?).to be false
        end
      end
    end

    context "not in a repository" do
      it "returns false" do
        repository = ::Helpers::EmptyRepository.new
        expect(self.described_class.installed?).to be false
        repository.remove
      end
    end
  end

end
