# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tails/version'

Gem::Specification.new do |spec|
  spec.name          = 'tails'
  spec.version       = Tails::VERSION
  spec.authors       = ['Pedro Gaspar']
  spec.email         = ['pedro.gaxpar@gmail.com']

  spec.summary       = 'A very simple Rails clone.'
  spec.description   = 'A very simple exploration of how to build a Ruby web framework. The result of reading Rebuilding Rails.'
  spec.homepage      = 'https://github.com/pgaspar'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'erubis'
  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'sqlite3'
end
