# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "can_opener/version"

Gem::Specification.new do |s|
  s.name        = "can_opener"
  s.version     = CanOpener::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brendon Murphy"]
  s.email       = ["xternal1+github@gmail.com"]
  s.homepage    = "http://github.com/bemurphy/can-opener"
  s.summary     = %q{Split up your CanCan Ability}
  s.description = %q{Split up your CanCan Ability by allowing you to easily create abilities in separate classes which you reference in your main ability model.  This is mainly useful if you want to break down your abilities into smaller classes for organizational purposes.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
