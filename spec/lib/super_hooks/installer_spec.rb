require 'spec_helper'

describe SuperHooks::Installer do
  let(:installer) { self.described_class.new }


  context "already installed" do
    describe "#run" do
      it "should raise an error" do
        expect(File).to receive(:exists?).with("#{@repository.path}/.git/hooks.old").and_return(true)
        expect($stderr).to receive(:puts).with("SuperHooks already installed")
        expect{
          installer.run
        }.to raise_error SystemExit
      end
    end
  end

  context "not installed" do
    context "before running the installer" do
      it "only has the one hooks folder" do
        expect(Dir[".git/hooks"]).to match_array(".git/hooks")
      end
    end

    context "after running the installer" do
      let(:files) { Dir[".git/hooks/*"].map{|x| File.expand_path x} }
      before(:each) do
        installer.run
      end

      it "created a new folder" do
        expect(Dir[".git/hooks*"]).to match_array([".git/hooks.old", ".git/hooks"])
      end

      it "creates a new executable for each of the hooks" do
        SuperHooks::Hooks.list.each do |hook|
          expect(files.map{|x| File.basename(x)}).to include hook
        end

        files.each do |file|
          expect(File.stat(file)).to be_executable
        end
      end

      it "each file has the same code" do
        code = <<-EOF.gsub(/^\s+/, '')
          #!/usr/bin/env ruby
          exec("super_hooks --run \#{File.basename(__FILE__)} \#{ARGV}")
        EOF

        files.each do |file|
          expect(File.read(file)).to eql code
        end
      end

    end

  end

  describe "uninstall" do

  end
end
