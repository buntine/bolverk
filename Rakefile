require 'spec'
require 'spec/rake/spectask'
require 'rake'

task :default => :spec

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ["--colour", "--format progress", "--loadby mtime", "--reverse"]
  t.spec_files = FileList[ 'spec/**/*_spec.rb' ]
end

desc "Run all specs and generate RCov report"
Spec::Rake::SpecTask.new('cov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ["--colour"]
  t.rcov = true
  t.rcov_opts = ['-T --no-html --exclude', 'spec\/,gems\/']
end


