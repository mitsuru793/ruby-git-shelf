require_relative '../test_helper'

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

    @tmpDir.write_yaml('repository_book.yml', book)
  end

  def test_requires_category
    skip
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
