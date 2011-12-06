# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tane/version"

Gem::Specification.new do |s|
  s.name        = "tane"
  s.version     = Tane::VERSION
  s.authors     = ["Sean Grove"]
  s.email       = ["s@gobushido.com"]
  s.homepage    = ""
  s.summary     = %q{Enables local development of Bushido apps}
  s.description = %q{This gem provides all the tools necessary to develop a rails app meant for deployment on Bushido locally}

  s.rubyforge_project = "tane"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "awesome_print"
  s.add_runtime_dependency "erubis"
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "highline"
end
