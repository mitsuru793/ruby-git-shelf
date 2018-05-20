require_relative '../test_helper'

class RestoreTest < GitShelfUnitTest
  def test_not_restore_locked_repository
    cache = book
    cache['repositories']['github.com/mike/repo3'][:can_clone] = false
    @tmpDir.write_yaml('repository_book.yml', cache)

    run_command(%w[restore])

    root = @config['shelf']['path']
    assert_exists("#{root}/php/github.com/jane/repo1")
    assert_exists("#{root}/ruby/github.com/mike/repo2")
    refute_exists("#{root}/ruby/github.com/mike/repo3")
  end
end
