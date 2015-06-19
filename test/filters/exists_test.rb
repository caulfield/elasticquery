require "test_helper"
require "elasticquery/filters/exists"

class TestExistsFilter < MiniTest::Test

  def test_valid_filter_has_present_field_name
    filter = Elasticquery::Filters::Exists.new "user"
    assert filter.valid?
  end

  def test_invalid_filter_has_blank_field_name
    filter = Elasticquery::Filters::Exists.new ""
    refute filter.valid?
  end

  def test_invalid_filter_has_no_field
    filter = Elasticquery::Filters::Exists.new
    refute filter.valid?
  end

  def test_to_hash_returns_elastic_rule
    filter = Elasticquery::Filters::Exists.new "user"
    assert_equal filter.to_hash, {exists: {field: "user"}}
  end

  def test_to_not_hash_returns_missing
    filter = Elasticquery::Filters::Exists.new "user"
    assert_equal filter.to_not_hash, {missing: {field: "user"}}
  end
end
