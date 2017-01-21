require "spec_helper"

describe SuperHooks::Hook do
  describe "LIST" do
    it "contains an array of all hooks" do
      expect(described_class::LIST).to eql(%w( applypatch-msg commit-msg post-applypatch post-checkout post-commit post-merge
                                               post-receive pre-applypatch pre-auto-gc pre-commit prepare-commit-msg pre-rebase
                                               pre-receive update pre-push ))
    end
  end

  let(:good_hook_path) { "/path/.git/git_hooks/commit-msg/foo" }
  let(:hook) { described_class.new(good_hook_path) }

  describe "::where" do
    let(:test_hook) { hook.path }
    let(:file) { instance_double("File") }
    let(:file_stat) { instance_double("File::Stat") }

    before do
      allow(file_stat).to receive(:executable?).and_return(true)
      allow(Dir).to receive(:[]).with(anything).and_return([])
      allow(File).to receive(:file?).with(anything).and_return true
      allow(File).to receive(:stat).with(anything).and_return(file_stat)
    end

    it "returns user hooks" do
      expect(Dir).to receive(:[]).with("#{ENV['HOME']}/.git_hooks/**/*").and_return([test_hook])
      expect(described_class).to receive(:new).with(anything).and_return(hook)
      hooks = described_class.where
      expect(hooks).to eq([hook])
    end

    it "returns project hooks" do
      expect(SuperHooks::Git).to receive(:repository).and_return("foo")
      expect(Dir).to receive(:[]).with("foo/.git/git_hooks/**/*").and_return([test_hook])
      expect(described_class).to receive(:new).with(anything).and_return(hook)
      hooks = described_class.where
      expect(hooks).to eq([hook])
    end

    it "returns global hooks" do
      expect(SuperHooks::Git).to receive(:command).with("config hooks.global").and_return("GLOBAL/HOOK/PATH")
      expect(Dir).to receive(:[]).with("GLOBAL/HOOK/PATH/**/*").and_return([test_hook])
      expect(described_class).to receive(:new).with(anything).and_return(hook)
      hooks = described_class.where
      expect(hooks).to eq([hook])
    end

    it "returns global hooks in multiple folders" do
      expect(SuperHooks::Git).to receive(:command).with("config hooks.global").and_return("/GLOBAL/HOOK/PATH,/GLOBAL/HOOK/PATH2")
      expect(Dir).to receive(:[]).with("/GLOBAL/HOOK/PATH/**/*").once.and_return([test_hook])
      expect(Dir).to receive(:[]).with("/GLOBAL/HOOK/PATH2/**/*").once.and_return([test_hook])
      expect(described_class).to receive(:new).twice.with(anything).and_return(hook)
      hooks = described_class.where
      expect(hooks).to eq([hook, hook])
    end

    it "does not return non-executable files" do
      allow(file_stat).to receive(:executable?).and_return(false)
      expect(Dir).to receive(:[]).with("#{ENV['HOME']}/.git_hooks/**/*").and_return([test_hook])
      hooks = described_class.where
      expect(hooks).to eq([])
    end

    it "does not return non directories" do
      allow(File).to receive(:file?).with(test_hook).and_return(false)
      expect(Dir).to receive(:[]).with("#{ENV['HOME']}/.git_hooks/**/*").and_return([test_hook])
      hooks = described_class.where
      expect(hooks).to eq([])
    end
  end

  describe "#initialize" do
    it "set the path to the actual hook" do
      hook = described_class.new("/path/to/hook")
      expect(hook.path).to eql("/path/to/hook")
    end
  end

  describe "#execute" do
    it "runs the script with the right arguments" do
      allow(hook).to receive(:path).and_return "path"
      expect(hook).to receive(:system).with("path super_argument", out: anything, err: anything).once.and_return(true)
      hook.execute!("super_argument")
    end
  end

  describe "#description" do
    it "run the script with the --about flag" do
      expect(hook).to receive(:`).with("/path/.git/git_hooks/commit-msg/foo --about").and_return("foo\n")
      expect(hook.description).to eql "foo"
    end
  end
end
