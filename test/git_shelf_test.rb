require "test_helper"

class GitShelfTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GitShelf::VERSION
  end
end
