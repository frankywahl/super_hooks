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
    let(:file2) {
      file = "#{@repository.path}/.git/git_hooks/pre-commit/foo"
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

    before(:each) do
      file
      file2
    end

    context "unfilterd" do

      let(:hooks) { self.described_class.new }

      describe "#list_with_description" do
        it "includes project hooks with their description" do
          expect(hooks.list_with_descriptions).to eql("#{file}" => "Just a check to see if it all works", "#{file2}" => "Just a check to see if it all works")
        end
      end

      describe "#list" do
        it "returns an array of active hooks" do
          expect(hooks.list).to match_array([file, file2])
          expect(hooks.list.count).to eql 2
        end

        it "does not include non-executable" do

        end
      end
    end

    context "filtered" do

      let(:hooks) { self.described_class.new(filters: %w(commit-msg)) }

      it "#list limits the output"  do
        expect(hooks.list).to match_array([file])
        expect(hooks.list.count).to eql 1
      end

      it "#list_with_description limits output with their description" do
        expect(hooks.list_with_descriptions).to eql("#{file}" => "Just a check to see if it all works")
      end

    end

  end
end
