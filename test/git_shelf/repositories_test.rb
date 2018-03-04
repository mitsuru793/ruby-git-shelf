require "test_helper"

require 'fileutils'
require 'yaml'
class RepositoriesTest < Minitest::Test
  def setup
    @tmpDir = TmpDir.new

    @git_paths = %w[
      ruby/github.com/mike/repo1
      ruby/github.com/mike/repo2
      php/github.com/jane/repo3
    ]
    @git_paths.each do |p|
      @tmpDir.createGitDir(p)
    end
  end

  def test_from_root_path
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)

    assert_equal(@git_paths.size, repositories.items.size)
    assert_all_item_instance_of(GitShelf::Repository, repositories.items)
  end

  def test_to_a
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)
    array = repositories.to_a

    assert_equal(@git_paths.size, repositories.items.size)
    assert_all_item_instance_of(Hash, array)
  end
end
