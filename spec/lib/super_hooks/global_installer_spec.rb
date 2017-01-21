require "spec_helper"

describe SuperHooks::Installer::Global do
  describe "#run" do
    let(:runner) { described_class.new }
    let(:home_dir) { Helpers::EmptyRepository.new(name: "foo_test") }

    before do
      stub_const("ENV", ENV.to_hash.merge("HOME" => home_dir.path))
      stub_const("SuperHooks::Hook::LIST", %w(foo))

      allow(SuperHooks::Git).to receive(:command).with(anything).and_return(nil)
    end

    after do
      home_dir.remove
    end

    context "templates already exists" do
      before do
        expect(File).to receive(:exist?).with("#{ENV['HOME']}/.git_global_templates").and_return(true)
      end

      it "does not create them" do
        expect(FileUtils).to receive(:mkdir_p).never
        expect(File).to receive(:open).never
        expect(SuperHooks::Git).to receive(:command).with("config --global init.templatedir #{ENV['HOME']}/.git_global_templates")
        runner.run
      end
    end

    context "templates do not exist" do
      before do
        expect(File).to receive(:exist?).with("#{ENV['HOME']}/.git_global_templates").and_return(false)
      end

      it "creates them" do
        file = double("file")
        expect(FileUtils).to receive(:mkdir_p).once.and_return(double.as_null_object)
        expect(File).to receive(:open).with("#{ENV['HOME']}/.git_global_templates/hooks/foo", "w", 0o755).once.and_yield(file)
        expect(file).to receive(:write).with(anything)
        runner.run
      end
    end
  end
end
