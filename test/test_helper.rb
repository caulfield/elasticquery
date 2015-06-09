require "minitest/test"
require "minitest/autorun"

require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
