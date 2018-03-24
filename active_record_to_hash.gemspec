$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_record_to_hash/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_record_to_hash"
  s.version     = ActiveRecordToHash::VERSION
  s.authors     = ["Masamoto Miyata"]
  s.email       = ["miyata@sincere-co.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActiveRecordToHash."
  s.description = "TODO: Description of ActiveRecordToHash."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.5"

  s.add_development_dependency "sqlite3"
end
