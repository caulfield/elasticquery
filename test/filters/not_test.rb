require "test_helper"
require "elasticquery/filters/not"

class NotFilter < MiniTest::Test
  attr_reader :filters

  def setup
    @filter = Elasticquery::Filters::Not.new a: 1
  end

  def test_always_valid
    filter = Elasticquery::Filters::Not.new
    assert filter.valid?
  end

  def test_to_hash_return_proc
    assert_instance_of Proc, @filter.to_hash
  end

  def test_valid_return_proc
    assert_instance_of Proc, @filter.valid?
  end

  def test_valid_proxy_to_previous_filter
    filter_class = MiniTest::Mock.new
    filter_class.expect :valid?, true
    previous_filter = MiniTest::Mock.new
    previous_filter.expect :dup_with, filter_class, [{a: 1}]

    @filters = [previous_filter, "current-not-filter"]
    assert instance_exec &@filter.valid?

    assert filter_class.verify
    assert previous_filter.verify
  end

  def test_to_hash_change_last_term_filter_value
    filter_class = MiniTest::Mock.new
    filter_class.expect :valid?, true
    expected = {not: {filter: {term: {a: 1, b: 2}}}}
    filter_class.expect :to_not_hash, expected
    previous_filter = MiniTest::Mock.new
    previous_filter.expect :dup_with, filter_class, [{a: 1}]

    @filters = [previous_filter, "current-not-filter"]
    result = instance_exec &@filter.to_hash
    assert_equal result, expected

    assert previous_filter.verify
  end

  def test_to_hash_change_last_range_filter_value
    filter_class = MiniTest::Mock.new
    filter_class.expect :valid?, true
    expected = {not: {filter: {range: {a: {lte: 1}}}}}
    filter_class.expect :to_not_hash, expected
    previous_filter = MiniTest::Mock.new
    previous_filter.expect :dup_with, filter_class, [{a: 1}]

    @filters = [previous_filter, "current-not-filter"]
    result = instance_exec &@filter.to_hash
    assert_equal result, expected

    assert previous_filter.verify
  end

  def test_based_new_raise_exception
    assert_raises StandardError do
      @filter.dup_with a: 1
    end
  end
end
