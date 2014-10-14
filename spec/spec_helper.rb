require 'simplecov'
require 'coveralls'
require 'codeclimate-test-reporter'
require 'pry'

CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end

formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

if ENV['CODECLIMATE_REPO_TOKEN']
  formatters << CodeClimate::TestReporter::Formatter
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[*formatters]
SimpleCov.coverage_dir 'log/coverage/rspec'
SimpleCov.start do
  add_filter 'vendor'
  add_filter 'spec'
end

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec','').gsub(/spec/, 'lib')
end
