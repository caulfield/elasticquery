require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run unit tests"
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = "test/**/**_test.rb"
  # t.verbose = true
  # t.warning = false
end

task default: :test
