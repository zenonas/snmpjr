# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snmpjr/version'

Gem::Specification.new do |spec|
  spec.name          = "snmpjr"
  spec.version       = Snmpjr::VERSION
  spec.authors       = ["Zen Kyprianou"]
  spec.email         = ["zen@kyprianou.eu"]
  spec.summary       = %q{Simple SNMP interface for JRuby}
  spec.description   = %q{Snmpjr aims to provide a clean and simple interface to use SNMP in your ruby code. It will wrap the popular SNMP4J library in Java.
}
  spec.homepage      = "https://github.com/zenonas/snmpjr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.platform      = "java"
end
