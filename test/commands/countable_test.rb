require_relative '../test_helper'

class CountableTest < GitShelfUnitTest
  def test_list_countable_categories
    output = capture {run_command(%w[countable])}
    expected = <<~EOF
    id
    name
    author
    host
    url
    category
    can_clone
    cloned_at
    EOF
    assert_equal(expected, output)
  end
end