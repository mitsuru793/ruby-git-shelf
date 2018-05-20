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

  def assert_exists(actual)
    unless (actual.is_a?(Pathname))
      actual = Pathname.new(actual)
    end
    path = actual.expand_path.to_s
    assert(File.exist?(path), 'Must exist: ' + path)
  end

  def refute_exists(actual)
    unless (actual.is_a?(Pathname))
      actual = Pathname.new(actual)
    end
    path = actual.expand_path.to_s
    refute(File.exist?(path), 'Must not exist: ' + path)
  end

  def assert_count(expected, actual)
    assert_equal(expected.size, actual, "Size must be #{expected}, but #{actual}.")
  end
end
