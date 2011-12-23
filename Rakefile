require 'rubygems'
require 'rubygems/package_task'

load './ranged_find.gemspec'

Gem::PackageTask.new($spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :default => :gem