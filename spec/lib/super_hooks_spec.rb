require "spec_helper"
require "super_hooks"

describe SuperHooks do
  it "has a VERSION constant" do
    expect(described_class.const_get("VERSION")).not_to be_empty
  end

  describe "#installed?" do
    context "in a git repository" do
      before do
        expect(SuperHooks::Git).to receive(:repository?).and_return true
        expect(SuperHooks::Git).to receive(:current_repository).and_return("/some/path/")
      end

      context "with a hooks.old folder" do
        it "returns true" do
          expect(File).to receive(:exist?).with("/some/path/.git/hooks.old/").and_return true
          expect(described_class).to be_installed
        end
      end

      context "without a hooks.old folder" do
        it "returns false" do
          expect(File).to receive(:exist?).with("/some/path/.git/hooks.old/").and_return false
          expect(described_class).not_to be_installed
        end
      end
    end

    context "not in a repository" do
      it "returns false" do
        expect(SuperHooks::Git).to receive(:repository?).and_return false
        expect(described_class).not_to be_installed
      end
    end
  end
end
