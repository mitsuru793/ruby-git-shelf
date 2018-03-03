require "test_helper"

class RepositoryTest < Minitest::Test
  def test_from_url
    url = 'https://github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_url(url)
    assert_equal('github.com', repository.host)
    assert_equal('mitsuru793', repository.author)
    assert_equal('ruby-git-shelf', repository.name)
    assert_equal(url, repository.url)
  end

  def test_from_path
    path = 'github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_path(path)
    assert_equal('github.com', repository.host)
    assert_equal('mitsuru793', repository.author)
    assert_equal('ruby-git-shelf', repository.name)
    assert_equal("https://#{path}", repository.url)
  end

  def test_shallow_clone
    skip
    url = 'https://github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_url(url)
    repository.shallowClone('hoge')
  end
end