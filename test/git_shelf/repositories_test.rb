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
      @tmpDir.create_git_dir(p)
    end
  end

  def test_from_root_path
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)

    assert_equal(@git_paths.size - 1, repositories.size)
    assert_all_item_instance_of(GitShelf::Repository, repositories)

    assert_raises ArgumentError do
      GitShelf::Repositories.from_root_path("#{@tmpDir}/missing")
    end
  end

  def test_from_array
    data = [repository_hash, repository_hash]
    repositories = GitShelf::Repositories.from_array('root', data)
    assert_instance_of(GitShelf::Repositories, repositories)

    assert_equal(data.size, repositories.size)
    assert(repositories.any? {|r| r.name == 'name1'})
    assert(repositories.any? {|r| r.name == 'name2'})
  end

  def test_from_hash
    repo1 = repository_hash
    repo2 = repository_hash
    repo1_id = sprintf('%s/%s/%s', repo1['host'], repo1['author'], repo1['name'])
    repo2_id = sprintf('%s/%s/%s', repo2['host'], repo2['author'], repo2['name'])
    data = {repo1_id => repo1, repo2_id => repo2}

    repositories = GitShelf::Repositories.from_hash('root', data)
    assert_instance_of(GitShelf::Repositories, repositories)

    assert_equal(data.size, repositories.size)
    assert(repositories.any? {|r| r.name == 'name1'})
    assert(repositories.any? {|r| r.name == 'name2'})
  end

  def test_to_a
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)
    array = repositories.to_a

    assert_equal(@git_paths.size - 1, repositories.size)
    assert_all_item_instance_of(Hash, array)
  end

  def test_to_h
    repositories = GitShelf::Repositories.from_root_path(@tmpDir.root)
    hashSet = repositories.to_h

    assert_equal(@git_paths.size - 1, repositories.size)
    assert_all_item_instance_of(Hash, hashSet)
    assert(hashSet.has_key?('github.com/mike/repo1'))
  end

  def test_from_count
    data = [
        repository_hash('category' => 'ruby'),
        repository_hash('category' => 'ruby'),
        repository_hash('category' => 'php'),
    ]
    repositories = GitShelf::Repositories.from_array('root', data)
    counter = repositories.count('category')

    expected = <<-EOF
+----------+-------+
| Category | Count |
+----------+-------+
| php      | 1     |
| ruby     | 2     |
+----------+-------+
    EOF
    assert_equal(expected.chomp, counter.to_table.to_s)
  end

  private
  def repository_hash(override = {})
    @dummy_repository_count += 1

    i = @dummy_repository_count
    {
        'name' => override['name'] || "name#{i}",
        'author' => override['author'] || "author#{i}",
        'host' => override['host'] || "host#{i}",
        'category' => override['category'] || "category#{i}",
        'cloned_at' => override['cloned_at'] || Time.now,
    }
  end
end
