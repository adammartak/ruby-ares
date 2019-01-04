$:.push File.expand_path('lib', __dir__)
require 'ruby-ares/version'

Gem::Specification.new do |s|
  s.name     = 'ruby-ares'
  s.version  = RubyARES::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary     = 'Gem for accesing business information from ARES database.'
  s.description = <<-EOF
                    ARES is the Czech business database maintained by Ministry of Finance of the Czech Republic.
                    This gem helps to retrieve data provided by this database.
                  EOF
  s.licenses = ['GPL-3.0']
  s.author   = 'Josef Strzibny'
  s.email    = 'strzibny@strzibny.name'
  s.homepage = 'http://github.com/strzibny/ruby-ares'
  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = '>= 1.8.0'
  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'nokogiri',              '~> 1.9'
  s.add_development_dependency 'rake',      '~> 12.3'
end
