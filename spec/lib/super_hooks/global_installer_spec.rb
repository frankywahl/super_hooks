require 'spec_helper'

describe SuperHooks::Installer::Global do

  describe "#run" do
    let(:runner) { self.described_class.new }

    let(:home_dir) { Helpers::EmptyRepository.new(name: "foo_test") }

    before :each do
      stub_const('ENV', ENV.to_hash.merge({"HOME" => home_dir.path}))
      stub_const("SuperHooks::Hook::LIST", %w(foo))

      allow(SuperHooks::Git).to receive(:command).with(anything).and_return(nil)
    end

    after :each do
      home_dir.remove
    end

    context "templates already exists" do

      before :each do
        expect(File).to receive(:exists?).with(ENV["HOME"] + "/.git_global_templates").and_return(true)
      end

      it "does not create them" do
        expect(FileUtils).to receive(:mkdir_p).never
        expect(File).to receive(:open).never
        expect(SuperHooks::Git).to receive(:command).with("config --global init.templatedir #{ENV["HOME"]}/.git_global_templates")
        runner.run
      end
    end

    context "templates do not exist" do

      before :each do
        expect(File).to receive(:exists?).with(ENV["HOME"] + "/.git_global_templates").and_return(false)
      end

      it "does not create them" do
        expect(FileUtils).to receive(:mkdir_p).once.and_return(double.as_null_object)
        expect(File).to receive(:open).with(anything, 'w', 0755).once.and_return(double.as_null_object)
        runner.run
      end
    end
  end
end
