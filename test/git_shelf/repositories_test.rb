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
    data = []
    data << {
        name: 'name1',
        author: 'author1',
        host: 'host1',
        category: 'category1',
        cloned_at: Time.now,
    }
    data << {
        name: 'name2',
        author: 'author2',
        host: 'host2',
        category: 'category2',
        cloned_at: Time.now,
    }
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
end
