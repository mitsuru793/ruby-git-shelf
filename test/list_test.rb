require "test_helper"

class ListTest < GitShelfUnitTest
  def setup
    super

    git_paths = %w[
      ruby/github.com/mike/repo1
      ruby/github.com/mike/repo2
      php/github.com/jane/repo3
      php/github.com/jane/repo3/sub/.git
    ]
    git_paths.each do |p|
      @tmpDir.create_git_dir(p)
    end

    book = {
        'repositories' => {
            'ruby/github.com/mike/repo1' => {
                id: 'ruby/github.com/mike/repo1',
                name: 'repo1',
                author: 'mike',
                host: 'github.com',
                url: 'https://github.com/mike/repo1',
                category: 'ruby',
                can_clone: true,
                cloned_at: @now,
                path: File.join(@tmpDir.root, 'ruby/github.com/mike/repo1')
            },
            'ruby/github.com/mike/repo2' => {
                id: 'ruby/github.com/mike/repo2',
                name: 'repo2',
                author: 'mike',
                host: 'github.com',
                url: 'https://github.com/mike/repo2',
                category: 'ruby',
                can_clone: true,
                cloned_at: @now,
                path: File.join(@tmpDir.root, 'ruby/github.com/mike/repo2')
            },
            'php/github.com/jane/repo3' => {
                id: 'php/github.com/jane/repo3',
                name: 'repo3',
                author: 'jane',
                host: 'github.com',
                url: 'https://github.com/jane/repo3',
                category: 'php',
                can_clone: true,
                cloned_at: @now,
                path: File.join(@tmpDir.root, 'php/github.com/jane/repo3')
            },
        },
    }
    @tmpDir.write_yaml('repository_book.yml', book)
  end

  def test_list_repositories_of_all_category
    output = capture {run_command(%w[list])}
    expected = <<~EOF
      ruby/github.com/mike/repo1
      ruby/github.com/mike/repo2
      php/github.com/jane/repo3
    EOF
    assert_equal(expected, output)
  end

  def test_list_repositories_of_one_category
    output = capture {run_command(%w[list ruby])}
    expected = <<~EOF
      ruby/github.com/mike/repo1
      ruby/github.com/mike/repo2
    EOF
    assert_equal(expected, output)
  end

  def test_list_no_repositories_of_invalid_category
    output = capture {run_command(%w[list not-exist])}
    assert_equal('', output.chomp)
  end

  def test_list_repositories_with_relative_path
    output = capture {run_command(%w[list --absolute-path])}
    root = @tmpDir.root.chomp('/')
    expected = <<~EOF
      #{root}/ruby/github.com/mike/repo1
      #{root}/ruby/github.com/mike/repo2
      #{root}/php/github.com/jane/repo3
    EOF
    assert_equal(expected, output)
  end
end