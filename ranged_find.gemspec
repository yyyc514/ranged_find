$spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Helpler for making date range queries easier in Rails"
  s.authors = "Josh Goebel"
  s.email = "me@joshgoebel.com"
  s.homepage = "https://github.com/yyyc514/ranged_find"
  s.name = 'ranged_find'
  s.version = "0.3"
  s.requirements << 'none'
  s.autorequire = 'ranged_find'
  
  s.files        = Dir["{lib}/**/*.rb", "MIT-LICENSE", "README"]
  s.require_path = 'lib'
  
  s.description = s.summary
end
