require "test_helper"

class CountTest < GitShelfUnitTest
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

  def test_requires_category
    e = assert_raises Thor::InvocationError do
      run_command(%w[count])
    end
    # TODO need to confirm error message for script file name
    expected = <<~EOF
      ERROR: "count_test.rb count" was called with no arguments
      Usage: "count_test.rb count CATEGORY"
    EOF
    assert_equal(expected.chomp, e.message)
  end

  def test_output_count_table_with_category
    output = capture {run_command(%w[count author])}

    expected = <<~EOF
      +--------+-------+
      | Author | Count |
      +--------+-------+
      | jane   | 1     |
      | mike   | 2     |
      +--------+-------+
    EOF
    assert_equal(expected, output)
  end

  def test_output_empty_with_invalid_category
    output = capture {run_command(%w[count nothing])}
    assert_equal('Invalid category: nothing', output.chomp)
  end
end
