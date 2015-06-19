require "test_helper"
require "elasticquery/filters/terms"

class TestTermsFilter < MiniTest::Test

  def test_valid_filter_should_have_one_key
    filter = Elasticquery::Filters::Terms.new a: 1
    assert filter.valid?
  end

  def test_invalid_filter_should_have_no_keys
    filter = Elasticquery::Filters::Terms.new
    refute filter.valid?
  end

  def test_valid_filter_should_have_2_and_more_keys
    filter = Elasticquery::Filters::Terms.new a: 1, b: 2
    assert filter.valid?
  end

  def test_valid_filter_could_have_cache_option
    filter = Elasticquery::Filters::Terms.new a: 1, _cache: false
    assert filter.valid?
  end

  def test_invalid_with_all_blank_values
    filter = Elasticquery::Filters::Terms.new a: "", b: nil
    refute filter.valid?
  end

  def test_valid_filter_could_have_execution_option
    filter = Elasticquery::Filters::Terms.new a: [1,2], b: 2, execution: "or"
    assert filter.valid?
  end

  def test_to_hash_should_pass_all_valid_conditions
    filter = Elasticquery::Filters::Terms.new a: 42, b: "42"
    assert_equal({terms: {a: 42, b: "42"}}, filter.to_hash)
  end

  def test_to_not_hash_should_returns_terms_not_condition
    filter = Elasticquery::Filters::Terms.new a: 42, b: "42"
    assert_equal({not: {filter: {terms: {a: 42, b: "42"}}}}, filter.to_not_hash)
  end

  def test_to_hash_should_skip_blank_values
    filter = Elasticquery::Filters::Terms.new a: 42, b: "", execution: "bool"
    assert_equal({terms: {a: 42, execution: "bool"}}, filter.to_hash)
  end
end
