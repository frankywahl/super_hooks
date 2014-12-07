require 'spec_helper'


describe SuperHooks::Hooks do
  describe "#list" do
    it "lists the set of hooks" do
      list = [
        "applypatch-msg",
        "commit-msg",
        "post-applypatch",
        "post-checkout",
        "post-commit",
        "post-merge",
        "post-receive",
        "pre-applypatch",
        "pre-auto-gc",
        "pre-commit",
        "prepare-commit-msg",
        "pre-rebase",
        "pre-receive",
        "update",
        "pre-push"
      ]
      expect(self.described_class.list).to eql list
    end
  end

  describe "installed hooks" do

    let(:hooks) { self.described_class.new }

    let(:file) {
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


    describe "#list_with_description" do
      it "includes project hooks with their description" do
        file # just create it
        expect(hooks.list_with_descriptions).to include("#{file}" => "Just a check to see if it all works")
      end
    end

    describe "#list" do
      it "returns an array of active hooks" do
        file
        expect(hooks.list).to match_array(file)
      end
    end

  end
end
