require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'

desc "Run unit tests"
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = "test/**/*_test.rb"
  # t.verbose = true
  # t.warning = false
end

desc "Generate docs"
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['--any', '--extra', '--opts']
  t.stats_options = ['--list-undoc']
end

task default: :test
