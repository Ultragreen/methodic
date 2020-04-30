Gem::Specification.new do |s|
  s.name = %q{methodic}
  s.author = "Romain GEORGES"
  s.version = "1.3"
  s.date = %q{2013-02-18}
  s.summary = %q{Methodic : Hash table options specification and validation componant}
  s.email = %q{romain@ultragreen.net}
  s.homepage = %q{https://github.com/Ultragreen/methodic}
  s.description = %q{Methodic : provide Hash table options arguments manager (specifications and validations}
  s.files = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.add_development_dependency 'rake', '~> 13.0.1'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'yard', '~> 0.9.24'
  s.add_development_dependency 'rdoc', '~> 6.2.1'
  s.add_development_dependency 'roodi', '~> 5.0.0'
  s.add_development_dependency 'code_statistics', '~> 0.2.13'
  s.add_development_dependency 'yard-rspec', '~> 0.1'
  s.rdoc_options << '--title' << 'Methodic : Gem documentation' << '--main' << 'doc/manual.rdoc' << '--line-numbers'
  # << '--diagram'
  s.license = "BSD-2-Clause"
end
