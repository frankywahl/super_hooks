require 'spec_helper'


describe SuperHooks::Hook do
  describe "LIST" do
    it "contains an array of all hooks" do
      expect(self.described_class::LIST).to eql(%w( applypatch-msg commit-msg post-applypatch post-checkout post-commit post-merge post-receive pre-applypatch pre-auto-gc pre-commit prepare-commit-msg pre-rebase pre-receive update pre-push ))
    end
  end

  let(:bad_hook) {
    file = "#{@repository.path}/.git/git_hooks/commit-msg/foo"
    Helpers::BadHook.new(file).path
  }

  let(:good_hook) {
    file = "#{@repository.path}/.git/git_hooks/commit-msg/foo"
    dirname = File.dirname(file)

    FileUtils.mkdir_p(dirname) unless File.directory? dirname

    content = <<-EOF.gsub(/^\s+/, '')
        #!/bin/bash
        function foo() {
          return
        }
        case "${1}" in
          --about )
            echo -n "Just a check to see if it all works"
            ;;

          * )
            foo "#@"
            ;;
        esac

    EOF

    File.open(file, 'w', 0755) do |f|
      f.puts content
    end
    file
  }

  let(:hook) { self.described_class.new(good_hook) }

  describe "#where" do
    let(:test_hook) { hook.path }
    let(:file){ double("file") }

    before :each do
      allow(file).to receive(:executable?).and_return(true)
      allow(Dir).to receive(:[]).with(anything).and_return([])
      allow(File).to receive(:file?).with(anything).and_return true
      allow(File).to receive(:stat).with(anything).and_return(file)
    end

    it "returns user hooks" do
      expect(Dir).to receive(:[]).with("#{ENV['HOME']}/.git_hooks/**/*").and_return([test_hook])
      expect(self.described_class).to receive(:new).with(anything).and_return(hook)
      hooks = self.described_class.where
      expect(hooks).to eq([hook])
    end

    it "returns project hooks" do
      expect(Dir).to receive(:[]).with("#{@repository.path}/.git/git_hooks/**/*").and_return([test_hook])
      expect(self.described_class).to receive(:new).with(anything).and_return(hook)
      hooks = self.described_class.where
      expect(hooks).to eq([hook])
    end

    it "returns global hooks" do
      expect(SuperHooks::Git).to receive(:command).with("config hooks.global").and_return("GLOBAL/HOOK/PATH")
      expect(Dir).to receive(:[]).with("GLOBAL/HOOK/PATH/**/*").and_return([test_hook])
      expect(self.described_class).to receive(:new).with(anything).and_return(hook)
      hooks = self.described_class.where
      expect(hooks).to eq([hook])
    end

    it "returns global hooks in multiple folders" do
      expect(SuperHooks::Git).to receive(:command).with("config hooks.global").and_return("/GLOBAL/HOOK/PATH,/GLOBAL/HOOK/PATH2")
      expect(Dir).to receive(:[]).with("/GLOBAL/HOOK/PATH/**/*").once.and_return([test_hook])
      expect(Dir).to receive(:[]).with("/GLOBAL/HOOK/PATH2/**/*").once.and_return([test_hook])
      expect(self.described_class).to receive(:new).twice.with(anything).and_return(hook)
      hooks = self.described_class.where
      expect(hooks).to eq([hook, hook])
    end

    it "does not return non-executable files" do
      allow(file).to receive(:executable?).and_return(false)
      expect(Dir).to receive(:[]).with("#{ENV['HOME']}/.git_hooks/**/*").and_return([test_hook])
      hooks = self.described_class.where
      expect(hooks).to eq([])
    end

    it "does not return non directories" do
      allow(File).to receive(:file?).with(test_hook).and_return(false)
      expect(Dir).to receive(:[]).with("#{ENV['HOME']}/.git_hooks/**/*").and_return([test_hook])
      hooks = self.described_class.where
      expect(hooks).to eq([])
    end

  end

  describe "#initialize" do
    it "set the path to the actual hook" do
      hook = self.described_class.new("/path/to/hook")
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
      expect(hook.description).to eql "Just a check to see if it all works"
    end
  end

end
