require_relative '../test_helper'

class GetTest < GitShelfUnitTest
  def test_save_with_category
    path = Pathname.new(@config['shelf']['path']).join('ruby').expand_path
    FileUtils.mkdir_p(path)

    run_command(%w[get ruby https://github.com/mitsuru793/ruby-git-shelf])
    assert_exists(@config['shelf']['path'] + '/ruby/github.com/mitsuru793/ruby-git-shelf/.git')

    book = YAML.load_file(File.expand_path(@config['repository_book']['path']))

    repos = book['repositories']
    assert_count(repos, 1)

    repo = repos['github.com/mitsuru793/ruby-git-shelf']
    assert_equal(repo[:id], 'github.com/mitsuru793/ruby-git-shelf')
    assert_equal(repo[:url], 'https://github.com/mitsuru793/ruby-git-shelf')
    assert_equal(repo[:name], 'ruby-git-shelf')
    assert_equal(repo[:author], 'mitsuru793')
    assert_equal(repo[:category], 'ruby')
    assert(repo[:can_clone])
    assert_equal(repo[:cloned_at].to_s, @now.to_s)
  end

  def test_update_cache_after_get
    path = Pathname.new(@config['shelf']['path']).join('ruby').expand_path
    FileUtils.mkdir_p(path)

    run_command(%w[get ruby https://github.com/mitsuru793/ruby-git-shelf])
    run_command(%w[get ruby https://github.com/mitsuru793/ruby-pin-note])

    book = YAML.load_file(File.expand_path(@config['repository_book']['path']))

    repos = book['repositories']
    assert_count(repos, 2)

    assert_includes(repos, 'github.com/mitsuru793/ruby-git-shelf')
    assert_includes(repos, 'github.com/mitsuru793/ruby-pin-note')
  end
end
