require "test_helper"

class RepositoryBookTest < Minitest::Test
  def setup
    @tmp = TmpDir.new
    @repositories_data = [
        {
            url: 'https://github.com/mike/repo1',
            name: 'repo1',
            author: 'mike',
            host: 'github.com',
            category: 'ruby',
        },
        {
            url: 'https://github.com/mike/repo2',
            name: 'repo2',
            author: 'mike',
            host: 'github.com',
            category: 'ruby',
        },
    ]
  end

  def test_load_cache_file
    config = {
        repository_book: "#{@tmp.root}/book.yml",
        shelf: "#{@tmp.root}/git-shelf/",
    }
    @tmp.write_yaml('book.yml', {repositories: @repositories_data})
    assert(File.exist?(config[:repository_book]))

    repository_book = GitShelf::RepositoryBook.load(config)
    repositories = repository_book.repositories
    assert_equal(2, repositories.size)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo1", repositories.fetch(0).path)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo2", repositories.fetch(1).path)
  end

  def test_load__without_cache_file
    config = {
        repository_book: "#{@tmp.root}/book.yml",
        shelf: "#{@tmp.root}/git-shelf/",
    }
    assert(!File.exist?(config[:repository_book]))

    @tmp.create_git_dirs(%W{
      git-shelf/ruby/github.com/mike/repo1
      git-shelf/ruby/github.com/mike/repo2
    })

    repository_book = GitShelf::RepositoryBook.load(config)
    repositories = repository_book.repositories
    assert_equal(2, repositories.size)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo1", repositories.fetch(0).path)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo2", repositories.fetch(1).path)
  end

  def test_save
    repositories = GitShelf::Repositories.from_array('/root', @repositories_data)
    GitShelf::RepositoryBook.new(repositories)

    assert_equal(2, repositories.size)
    assert_equal('/root/ruby/github.com/mike/repo1', repositories.fetch(0).path)
    assert_equal('/root/ruby/github.com/mike/repo2', repositories.fetch(1).path)
  end
end