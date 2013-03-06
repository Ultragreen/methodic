Gem::Specification.new do |s|
  s.name = %q{methodic}
  s.author = "Romain GEORGES"
  s.version = "1.2"
  s.date = %q{2013-02-18}
  s.summary = %q{Methodic : Hash table options specification and validation componant}
  s.email = %q{romain@ultragreen.net}
  s.homepage = %q{http://www.ultragreen.net}
  s.description = %q{Methodic : provide Hash table options arguments manager (specifications and validations}
  s.has_rdoc = true
  s.files = Dir['*/*/*/*'] + Dir['*/*/*'] + Dir['*/*'] + Dir['*']
  s.bindir = nil
  s.required_ruby_version = '>= 1.8.1'
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.rdoc_options << '--title' << 'Methodic : Gem documentation' << '--main' << 'doc/manual.rdoc' << '--line-numbers' 
  # << '--diagram'
  s.rubyforge_project = "nowarning"
end