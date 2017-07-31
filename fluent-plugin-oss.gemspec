# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-oss"
  gem.description = "Aliyun oss output plugin for Fluentd event collector"
  gem.license     = "MIT"
  gem.homepage    = ""
  gem.summary     = gem.description
  gem.version     = File.read("VERSION").strip
  gem.authors     = ["sjtubreeze"]
  gem.email       = "sjtubreeze@163.com"
  gem.has_rdoc    = false
  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency "fluentd", [">= 0.12.3"]
  gem.add_dependency "aliyun-sdk", [">= 0.6.0"]
  gem.add_development_dependency "rake", ">= 0.9.2"
  gem.add_development_dependency "test-unit", ">= 3.0.8"
end
