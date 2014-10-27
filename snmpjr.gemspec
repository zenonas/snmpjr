# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snmpjr/version'

Gem::Specification.new do |spec|
  spec.name          = 'snmpjr'
  spec.version       = Snmpjr::VERSION
  spec.authors       = ['Zen Kyprianou']
  spec.email         = ['zen@kyprianou.eu']
  spec.summary       = 'Simple SNMP interface for JRuby'
  spec.description   = 'Snmpjr aims to provide a clean and simple interface to use SNMP in your ruby code. It will wrap the popular SNMP4J library in Java.'
  spec.homepage      = 'https://github.com/zenonas/snmpjr'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.platform      = 'java'
  spec.add_development_dependency 'rake-n-bake'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'semver2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
end
