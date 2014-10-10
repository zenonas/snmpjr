require 'rake/clean'
require 'rake_rack'

@external_dependencies = %w[jruby java]

task :default => [
  :clean,
  :"rake_rack:check_external_dependencies",
  :"rake_rack:code_quality:all",
  :"rake_rack:rspec",
  :"rake_rack:coverage:check_specs",
  :"rake_rack:ok",
]
