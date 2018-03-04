require "test_helper"

class CounterTest < Minitest::Test
  def test_to_table
    counter = GitShelf::Counter.new('user')
    counter.succ!('man')
    counter.succ!('man')
    counter.succ!('woman')
    counter.succ!('unknown')
    counter.succ!('unknown')
    counter.succ!('unknown')

    actual = counter.to_table
    assert_instance_of(Terminal::Table, actual)

    expected = <<-EOF
+---------+-------+
| User    | Count |
+---------+-------+
| woman   | 1     |
| man     | 2     |
| unknown | 3     |
+---------+-------+
    EOF
    assert_equal(expected.chomp, actual.to_s)
  end
end