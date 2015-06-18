require "test_helper"
require "elasticquery/filters/range"

class RangeFilter < MiniTest::Test
  def setup
    @filter = Elasticquery::Filters::Range.new "year", lte: 2015, gte: 1990
    @lte_filter = Elasticquery::Filters::Range.new "age", lte: 58
    @gte_filter = Elasticquery::Filters::Range.new "age", gte: 18
  end

  def test_filter_valid_if_has_at_least_lte_or_gte_option
    filter = Elasticquery::Filters::Range.new "year", lte: 1
    assert filter.valid?
    filter = Elasticquery::Filters::Range.new "year", gte: 0
    assert filter.valid?
  end

  def empty_values_is_invalid
    filter = Elasticquery::Filters::Range.new "year", lte: "  "
    assert filter.invalid?
    filter = Elasticquery::Filters::Range.new "year", gte: nil, lte: ""
    assert filte.invalid?
  end

  def test_filter_invalid_if_has_no_options
    filter = Elasticquery::Filters::Range.new "year"
    refute filter.valid?
  end

  def test_to_hash_should_return_query
    filter = Elasticquery::Filters::Range.new :year, lte: 1, gte: 0
    assert_equal({range: {year: {lte: 1, gte: 0}}}, filter.to_hash)
  end

  def test_to_hash_with_one_param
    filter = Elasticquery::Filters::Range.new :year, lte: 1
    assert_equal({range: {year: {lte: 1}}}, filter.to_hash)
  end

  def test_to_hash_support_cache_option
    filter = Elasticquery::Filters::Range.new :year, lte: 1, _cache: true
    assert_equal({range: {year: {_cache: true, lte: 1}}}, filter.to_hash)
  end

  def test_to_hash_support_execution_option
    filter = Elasticquery::Filters::Range.new :year, lte: 1, gte: 0, execution: "fielddata"
    assert_equal({range: {year: {lte: 1, gte: 0, execution: "fielddata"}}}, filter.to_hash)
  end

  def test_to_hash_skip_unnesessary_options
    filter = Elasticquery::Filters::Range.new :year, lte: 1, _cache: true, extra: false
    assert_equal({range: {year: { _cache: true, lte: 1}}}, filter.to_hash)
  end

  def test_dup_with_return_new_range_filter
    filter = Elasticquery::Filters::Range.new "year"
    new_filter = filter.dup_with "month", gte: 12
    assert_kind_of Elasticquery::Filters::Range, new_filter
  end
end
