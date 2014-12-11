require 'spec_helper'
require 'super_hooks'

describe SuperHooks do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).not_to be_empty
  end

  describe "#installed?" do

    context "in a git repository" do
      before(:each) do
        expect(SuperHooks::Git).to receive(:repository?).and_return true
        expect(SuperHooks::Git).to receive(:current_repository).and_return("/some/path/")
      end

      context "with a hooks.old folder" do
        it "returns true" do
          expect(File).to receive(:exists?).with("/some/path/.git/hooks.old/").and_return true
          expect(self.described_class.installed?).to be true
        end
      end

      context "without a hooks.old folder" do
        it "returns false" do
          expect(File).to receive(:exists?).with("/some/path/.git/hooks.old/").and_return false
          expect(self.described_class.installed?).to be false
        end
      end
    end

    context "not in a repository" do
      it "returns false" do
        expect(SuperHooks::Git).to receive(:repository?).and_return false
        expect(self.described_class.installed?).to be false
      end
    end
  end

end
