require 'minitest/assertions'

module Minitest::Assertions
  def assert_all_item_instance_of(expected, actual)
    actual.each do |item|
      assert_instance_of(expected, item)
    end
  end
end
