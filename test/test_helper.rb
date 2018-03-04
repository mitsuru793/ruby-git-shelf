$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "minitest/autorun"
require "awesome_print"

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
  def createGitDir(dir)
    git_dir = FileUtils.mkdir_p("#{@root}/#{dir}")[0]
    Dir.mkdir("#{git_dir}/.git")
    return git_dir
  end
end

