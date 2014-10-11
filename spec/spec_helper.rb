require 'simplecov'
require_relative '../lib/snmpjr'

SimpleCov.start do
  add_filter '/vendor/'
  coverage_dir 'log/coverage/spec'
end

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec','').gsub(/spec/, 'lib')
end
