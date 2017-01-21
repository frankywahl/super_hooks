module Helpers
  class Repository
    attr_accessor :path
    attr_reader :cwdir

    def initialize
      @cwdir = `pwd`.chomp
    end

    def remove
      Dir.chdir cwdir
      FileUtils.rm_rf path
    end
  end

  class EmptyRepository < Repository
    def initialize(name: 'git_test')
      super()
      dir_name = name.to_s + Time.now.to_i.to_s + rand(300).to_s.rjust(3, '0')
      path = Dir.mktmpdir(dir_name)
      Dir.chdir path
      @path = `pwd`.chomp
    end
  end

  class GitRepository < EmptyRepository
    def initialize
      super()
      File.open('tmp.txt', 'w') do |f|
        f.puts 'text'
      end
      git_temp_dir = `git config --global init.templatedir`.chomp
      `git config --global --unset init.templatedir` unless git_temp_dir.empty?
      `git init`
      `git add . && git commit -m "WIP"`
      `git config --global init.templatedir #{git_temp_dir}` unless git_temp_dir.empty?
      path
    end
  end

  class Hook
    attr_reader :path

    def initialize(file, content)
      @path = file
      dirname = File.dirname(path)
      FileUtils.mkdir_p(dirname) unless File.directory? dirname
      File.open(path, 'w', 0o777) do |f|
        f.puts content
      end
    end
  end

  class BadHook < Hook
    def initialize(file)
      content = <<-EOF.gsub(/^\s+/, '')
        #!/bin/bash
        exit 1
      EOF
      super(file, content)
    end
  end
end
