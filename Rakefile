require 'rake/clean'
require 'rake_n_bake'
require 'rubocop/rake_task'

@external_dependencies = %w( jruby java )

RuboCop::RakeTask.new

task default: [
  :clean,
  :"bake:check_external_dependencies",
  :"bake:code_quality:all",
  :"bake:rspec",
  :"bake:coverage:check_specs",
  :"bake:ok"
]
