require 'minitest/assertions'

module Minitest::Assertions
  def assert_all_item_instance_of(expected, actual)
    if actual.kind_of?(Hash)
      actual.each_value do |item|
        assert_instance_of(expected, item)
      end
    else
      actual.each do |item|
        assert_instance_of(expected, item)
      end
    end
  end
end
