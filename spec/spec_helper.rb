require 'simplecov'
require 'pry'

SimpleCov.coverage_dir 'log/coverage/rspec'
SimpleCov.add_filter "spec"
SimpleCov.add_filter "vendor"
SimpleCov.start

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec','').gsub(/spec/, 'lib')
end
