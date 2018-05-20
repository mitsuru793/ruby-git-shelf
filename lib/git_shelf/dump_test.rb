require "test_helper"

class DumpTest < GitShelfUnitTest
  def setup
    super

    git_paths = %w[
      php/github.com/jane/repo1
      php/github.com/jane/repo1/sub/.git
      ruby/github.com/mike/repo2
      ruby/github.com/mike/repo3
    ]
    git_paths.each do |p|
      @tmpDir.create_git_dir(p)
    end
  end

  def test_create_yaml_from_cloned_repositories
    book_path = File.expand_path(@config['repository_book']['path'])
    File.delete(book_path) if File.exist?(book_path)

    mock = MiniTest::Mock.new
    mock.expect(:birthtime, @now)
    mock.expect(:birthtime, @now)
    mock.expect(:birthtime, @now)
    File::Stat.stub :new, mock do
      run_command(%w[dump])
    end

    expected = book
    actual = YAML.load_file(book_path)

    assert_equal(expected, actual)
  end
end

