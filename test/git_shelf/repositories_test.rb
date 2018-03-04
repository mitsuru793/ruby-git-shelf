require "test_helper"

require 'fileutils'
require 'yaml'
class RepositoriesTest < Minitest::Test
  def setup
    @tmpDir = TmpDir.new
    @dummy_repository_count = 0

    @git_paths = %w[
      ruby/github.com/mike/repo1
      ruby/github.com/mike/repo2
      php/github.com/jane/repo3
      php/github.com/jane/repo3/sub/.git
    ]
    @git_paths.each do |p|
      @tmpDir.createGitDir(p)
    end
  end

  def test_from_root_path
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)

    assert_equal(@git_paths.size - 1, repositories.items.size)
    assert_all_item_instance_of(GitShelf::Repository, repositories.items)
  end

  def test_from_array
    data = [repository_hash, repository_hash]
    repositories = GitShelf::Repositories.from_array(data)
    assert_instance_of(GitShelf::Repositories, repositories)

    assert_equal(data.size, repositories.items.size)
    assert(repositories.items.any? {|r| r.name == 'name1'})
    assert(repositories.items.any? {|r| r.name == 'name2'})
  end

  def test_to_a
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)
    array = repositories.to_a

    assert_equal(@git_paths.size - 1, repositories.items.size)
    assert_all_item_instance_of(Hash, array)
  end

  private
  def repository_hash(override = {})
    @dummy_repository_count += 1

    i = @dummy_repository_count
    {
        name: override[:name] || "name#{i}",
        author: override[:author] || "author#{i}",
        host: override[:host] || "host#{i}",
        category: override[:category] || "category#{i}",
        cloned_at: override[:cloned_at] || Time.now,
    }
  end
end
