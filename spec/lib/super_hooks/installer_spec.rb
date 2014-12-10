require 'spec_helper'

describe SuperHooks::Installer do
  let(:installer) { self.described_class.new }


  context "already installed" do
    before(:each) do
      expect(File).to receive(:exists?).with("#{@repository.path}/.git/hooks.old").and_return(true)
    end

    describe "#run" do
      it "should raise an error" do
        expect($stderr).to receive(:puts).with("SuperHooks already installed")
        expect{
          installer.run
        }.to raise_error SystemExit
      end
    end

    describe "#uninstalll" do

      before(:each) do
        `mkdir -p #{@repository.path}/.git/hooks.old/foo`
      end

      it "removes the new hooks directory" do
        allow(FileUtils).to receive(:rm_rf).with(anything)
        expect(FileUtils).to receive(:rm_rf).with("#{@repository.path}/.git/hooks/")
        installer.uninstall
      end

      it "renames the old directory to the new directory" do
        expect(FileUtils).to receive(:mv).with("#{@repository.path}/.git/hooks.old/", "#{@repository.path}/.git/hooks")
        installer.uninstall
      end

    end
  end

  context "with super hooks not installed" do
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
        SuperHooks::Hook::LIST.each do |hook|
          expect(files.map{|x| File.basename(x)}).to include hook
        end

        files.each do |file|
          expect(File.stat(file)).to be_executable
        end
      end

      it "each file has the same code" do
        code = <<-EOF.gsub(/^\s+/, '')
          #!/usr/bin/env ruby
          require 'super_hooks'
          SuperHooks::Runner.new(File.basename(__FILE__), ARGV).run
        EOF

        files.each do |file|
          expect(File.read(file)).to eql code
        end
      end


    end
    describe "#uninstall" do
      it "should raise an error" do
        expect(File).to receive(:exists?).with("#{@repository.path}/.git/hooks.old").and_return(false)
        expect($stderr).to receive(:puts).with(anything)
        begin
          installer.uninstall
        rescue SystemExit => e
          expect(e.status).to eql 1
        end
      end
    end

  end

end
