require "test_helper"

class RepositoryTest < Minitest::Test
  def test_from_url
    url = 'https://github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_url(url, 'ruby')
    assert_equal('github.com', repository.host)
    assert_equal('mitsuru793', repository.author)
    assert_equal('ruby-git-shelf', repository.name)
    assert_equal(url, repository.url)
    assert_equal('ruby', repository.category)
  end

  def test_from_path
    path = 'github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_path(path, 'ruby')
    assert_equal('github.com', repository.host)
    assert_equal('mitsuru793', repository.author)
    assert_equal('ruby-git-shelf', repository.name)
    assert_equal("https://#{path}", repository.url)
    assert_equal('ruby', repository.category)
  end

  def test_shallow_clone
    skip
    url = 'https://github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_url(url, 'ruby')
    repository.shallowClone('hoge')
  end

  def to_h
    path = 'github.com/mitsuru793/ruby-git-shelf'
    repository = GitShelf::Repository.from_path(path, 'ruby')
    hash = repository.to_h

    assert_equal('github.com', hash[:host])
    assert_equal('mitsuru793', hash[:author])
    assert_equal('ruby-git-shelf', hash[:name])
    assert_equal(url, hash[:url])
    assert_equal('ruby', hash[:category])
  end
end