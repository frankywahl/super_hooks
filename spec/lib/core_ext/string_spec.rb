require 'spec_helper'

describe String do

  let(:long_string) { "abcdefghijklmnopqrstuvwxyz" * 5 }

  context "#truncat_at_start" do
    it "with omission" do
      expect(long_string.truncate_at_start(5, omission: '...', separator: ' ')).to eql "...yz"
    end

    it "without omission" do
      expect(long_string.truncate_at_start(5)).to eql "...yz"
    end
  end

  context "#truncat_at" do
    it "with omission" do
      expect(long_string.truncate(5, omission: '...', separator: ' ')).to eql "ab..."
    end

    it "without omission" do
      expect(long_string.truncate(5)).to eql "ab..."
    end
  end

  context "#strip_heredoc" do

    it "removes the start" do
      bar =<<-EOF
Hello
World
  OK
      EOF

      result =<<-EOF.strip_heredoc
      Hello
      World
        OK
      EOF
      expect(result).to eql(bar)
    end

    it "worsk with no blank lines" do
      bar = <<-EOF
BAR
      EOF

      expect(bar.strip_heredoc).to eql("BAR\n")
    end

  end
end
