require "test_helper"

class RepositoryTest < Minitest::Test
  def setup
    @tmpDir = TmpDir.new
  end

  def test_from_url
    url = 'https://github.com/mitsuru793/ruby-git-shelf'
    cloned_at = Time.now
    repository = GitShelf::Repository.from_url('root', url, 'ruby', cloned_at)
    assert_equal('root/ruby/github.com/mitsuru793/ruby-git-shelf', repository.path)
    assert_equal('github.com', repository.host)
    assert_equal('mitsuru793', repository.author)
    assert_equal('ruby-git-shelf', repository.name)
    assert_equal(url, repository.url)
    assert_equal('ruby', repository.category)
    assert_equal(cloned_at, repository.cloned_at)
  end

  def test_from_path
    git_dir = 'ruby/github.com/mitsuru793/ruby-git-shelf'
    path = @tmpDir.create_git_dir(git_dir)
    repository = GitShelf::Repository.from_path('root', path)
    assert_equal('root/ruby/github.com/mitsuru793/ruby-git-shelf', repository.path)
    assert_equal('github.com', repository.host)
    assert_equal('mitsuru793', repository.author)
    assert_equal('ruby-git-shelf', repository.name)
    assert_equal('https://github.com/mitsuru793/ruby-git-shelf', repository.url)
    assert_equal('ruby', repository.category)
    assert_equal_birthtime(path, repository.cloned_at)
  end

  def test_shallow_clone
    skip
    url = 'https://github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_url('root', url, 'ruby', Time.now)
    repository.shallow_clone
  end

  def test_to_h
    git_dir = 'ruby/github.com/mitsuru793/ruby-git-shelf'
    path = @tmpDir.create_git_dir(git_dir)
    repository = GitShelf::Repository.from_path('root', path)
    hash = repository.to_h

    refute(hash.has_key?(:path))
    refute(hash.has_key?(:root))
    assert_equal('github.com', hash[:host])
    assert_equal('mitsuru793', hash[:author])
    assert_equal('ruby-git-shelf', hash[:name])
    assert_equal('https://github.com/mitsuru793/ruby-git-shelf', hash[:url])
    assert_equal('ruby', hash[:category])
    assert_equal_birthtime(path, hash[:cloned_at])
  end

  private

  # @param path [String]
  # @return [Time, nil]
  def assert_equal_birthtime(path, actual)
    begin
      expected = File::Stat.new(path).birthtime
      assert_equal(expected, actual)
    rescue NotImplementedError
      assert_nil(actual)
    end
  end
end