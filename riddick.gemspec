require File.expand_path '../lib/riddick/version', __FILE__

Gem::Specification.new do |gem|
  gem.name = 'riddick'
  gem.version = Riddick.version
  gem.description = %{
    Riddick is a simple Sintra based GUI for Redis-I18n-backend.
    It provides a list of preconfigured translations (via YAML-backend).
    Also you can add your translations to Redis-backend.
  }
  gem.summary = 'Simple GUI for Redis-I18n-backend'
  gem.homepage = 'https://github.com/kostia/riddick'
  gem.authors = ['Kostiantyn Kahanskyi']
  gem.email = %w[kostiantyn.kahanskyi@googlemail.com]
  gem.files = `git ls-files`.split("\n")
  gem.require_paths = %w[lib]
  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'i18n'
  gem.add_dependency 'redis'
  gem.add_dependency 'sinatra'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yajl-ruby'
end
