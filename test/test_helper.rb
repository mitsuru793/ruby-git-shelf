$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

# stdlib
require 'fileutils'
require 'yaml'

# 3rd party
require "minitest/autorun"
require "awesome_print"

require "git_shelf"
require "custom_assertions"


module GitShelf
  class Git
    class << self
      def clone(src, dest, options)
        FileUtils.mkdir_p(File.join(dest, '.git'))
      end
    end
  end
end

class TmpDir
  # @param [String]
  attr_reader :root

  def initialize
    @root = Dir.mktmpdir
  end

  def to_s
    @root
  end

  # @param dir [String] directory path
  # @return [String]
  def create_git_dir(dir)
    git_dir = FileUtils.mkdir_p("#{@root}/#{dir}")[0]
    Dir.mkdir("#{git_dir}/.git")
    git_dir
  end

  # @param dirs [Array<String>] directory paths
  # @return [Array<String>]
  def create_git_dirs(dirs)
    dirs.map {|dir| create_git_dir(dir)}
  end

  # @param path [String]
  # @return [String]
  def mkdir(path)
    joined_path = "#{@root}/#{path}"
    FileUtils.mkdir_p(joined_path)
    joined_path
  end

  # @param path [String]
  # @return [String]
  def read(path)
    File.read("#{@root}/#{path}")
  end

  # @param path [String]
  # @param content [String]
  # @return [String]
  def write(path, content)
    joined_path = "#{@root}/#{path}"
    File.write(joined_path, content)
    joined_path
  end

  # @param path [String]
  # @param data [Object]
  # @return [String]
  def write_yaml(path, data)
    joined_path = "#{@root}/#{path}"
    File.open(joined_path, 'w') do |f|
      YAML.dump(data, f)
    end
    joined_path
  end
end

class GitShelfUnitTest < Minitest::Test
  def setup
    tmp_root = File.expand_path('../../tmp', __FILE__)

    @now = Time.new
    @config = {
        'shelf' => {
            'path' => tmp_root
        },
        'repository_book' => {
            'path' => tmp_root + '/repository_book.yml',
        }
    }
    FileUtils.mkdir_p(tmp_root.to_s)

    @config_path = File.join(tmp_root, '.git-shelf')
    File.open(@config_path, 'w') do |f|
      YAML.dump(@config, f)
    end
  end

  def teardown
    FileUtils.rm_r(@config['shelf']['path']) if File.exist?(@config['shelf']['path'])
    File.delete(@config_path) if File.exist?(@config_path)
  end

  private
  def run_command(args)
    args.push('--config-path', @config_path)

    Time.stub :now, @now do
      GitShelf::Cli.start(args, debug: true)
    end
    YAML.load_file(File.expand_path(@config['repository_book']['path']))
  end

  def capture
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end

