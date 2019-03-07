require_relative '../test_helper'

class ConfigTest < GitShelfUnitTest
  def test_get_value_from_confg_yaml
    expected = File.expand_path(@config['shelf']['path'])
    output = capture {run_command(%w[config shelf.path])}
    assert_equal(expected, output.chomp)
  end
end
