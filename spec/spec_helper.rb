require 'simplecov'
require_relative '../lib/snmpjr'

SimpleCov.start do
  add_filter '/vendor/'
  coverage_dir 'log/coverage/spec'
end
