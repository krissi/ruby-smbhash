Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'smbhash'
  s.version     = '1.0.1'
  s.license     = 'MIT'
  s.summary     = "Lanman/NT hash generator"
  s.description = "An implementation of lanman and nt md4 hash functions for use in Samba style smbpasswd entries"
  s.homepage    = 'https://github.com/krissi/ruby-smbhash'
  s.author      = 'Christian Haase'

  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.8.7'

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", '~> 2.14'
end
