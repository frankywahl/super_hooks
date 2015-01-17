require 'spec_helper'

describe SuperHooks::Presenters::HookPresenter do
  let(:hook) do
    double('hook',
           description: 'Runs migrations and bundle if need be',
           path: '/some/path/to/hook/file.rb')
  end

  let(:presenter) { described_class.new(hook, max_length: 80) }

  describe '#print' do
    it 'gives out the right information' do
      text = <<-EOF.strip_heredoc
        /some/path/to/hook/file.rb
            ~> Runs migrations and bundle if need be
      EOF
      expect(presenter.print).to eql(text)
    end
  end
end
