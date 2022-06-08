lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easycrypto/version'

Gem::Specification.new do |spec|
  spec.name          = 'easy-crypto'
  spec.version       = EasyCrypto::VERSION
  spec.authors       = ['Emarsys Security']
  spec.email         = ['security@emarsys.com']

  spec.summary       = 'Provides simple wrappers around openssl crypto implementation.'
  spec.homepage      = 'https://github.com/emartech/ruby-easy-crypto'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3.15'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
