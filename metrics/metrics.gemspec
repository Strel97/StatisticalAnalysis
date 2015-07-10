$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "metrics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "metrics"
  s.version     = Metrics::VERSION
  s.authors     = ["Strel97"]
  s.email       = ["strel97@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Metrics."
  s.description = "TODO: Description of Metrics."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
end
