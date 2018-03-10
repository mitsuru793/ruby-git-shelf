$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "minitest/autorun"
require "awesome_print"
require 'fileutils'
require 'yaml'

require "git_shelf"
require "custom_assertions"

class TmpDir
  # @param [String]
  attr_reader :root

  def initialize
    @root = Dir.mktmpdir
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

