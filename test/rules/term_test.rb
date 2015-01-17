require 'test_helper'
require 'elasticquery/rules/term'

class TestTermRule < MiniTest::Test

  def test_valid_rule_should_have_one_key
    rule = Elasticquery::Rules::Term.new a: 1
    assert rule.valid?
  end

  def test_invalid_rule_should_have_no_keys
    rule = Elasticquery::Rules::Term.new
    refute rule.valid?
  end

  def test_invalid_rule_should_have_2_and_more_keys
    rule = Elasticquery::Rules::Term.new  a: 1, b: 2
    refute rule.valid?
  end

  def test_to_hash_should_return_es_query
    rule = Elasticquery::Rules::Term.new a: 1
    assert_equal({query: {filtered: {filter: {:and => {a: 1}}}}}, rule.to_hash)
  end
end
