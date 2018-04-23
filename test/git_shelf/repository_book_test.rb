require "test_helper"

class RepositoryBookTest < Minitest::Test
  def setup
    @tmp = TmpDir.new
    @repositories_data = [
        {
            'url' => 'https://github.com/mike/repo1',
            'name' => 'repo1',
            'author' => 'mike',
            'host' => 'github.com',
            'category' => 'ruby',
        },
        {
            'url' => 'https://github.com/mike/repo2',
            'name' => 'repo2',
            'author' => 'mike',
            'host' => 'github.com',
            'category' => 'ruby',
        },
    ]
  end

  def test_load_cache_file
    config_path = @tmp.write_yaml('config.yml', {
        'repository_book' => {'path' => "#{@tmp.root}/book.yml"},
        'shelf' => {'path' => "#{@tmp.root}/git-shelf/"},
    })
    config = GitShelf::Config.load_file(config_path)
    @tmp.write_yaml('book.yml', {'repositories' => @repositories_data})
    assert(config.repository_book.path.exist?)

    repository_book = GitShelf::RepositoryBook.load(config)
    repositories = repository_book.repositories
    assert_equal(2, repositories.size)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo1", repositories.fetch(0).path.to_s)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo2", repositories.fetch(1).path.to_s)
  end

  def test_load_without_cache_file
    config_path = @tmp.write_yaml('config.yml', {
        'repository_book' => {'path' => "#{@tmp.root}/book.yml"},
        'shelf' => {'path' => "#{@tmp.root}/git-shelf/"},
    })
    config = GitShelf::Config.load_file(config_path)
    refute(config.repository_book.path.exist?)

    @tmp.create_git_dirs(%W{
      git-shelf/ruby/github.com/mike/repo1
      git-shelf/ruby/github.com/mike/repo2
    })

    repository_book = GitShelf::RepositoryBook.load(config)
    repositories = repository_book.repositories
    assert_equal(2, repositories.size)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo1", repositories.fetch(0).path.to_s)
    assert_equal("#{@tmp.root}/git-shelf/ruby/github.com/mike/repo2", repositories.fetch(1).path.to_s)
  end

  def test_save
    repositories = GitShelf::Repositories.from_array('/root', @repositories_data)
    GitShelf::RepositoryBook.new(repositories)

    assert_equal(2, repositories.size)
    assert_equal('/root/ruby/github.com/mike/repo1', repositories.fetch(0).path.to_s)
    assert_equal('/root/ruby/github.com/mike/repo2', repositories.fetch(1).path.to_s)
  end
end