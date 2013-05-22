require File.expand_path '../lib/riddick/version', __FILE__

Gem::Specification.new do |gem|
  gem.name = 'riddick'
  gem.version = Riddick.version
  gem.description = %{
    Riddick is a simple Sintra app providing a GUI for key-value-backends for I18n.
    By default it uses Redis as I18n backend for translations,
    but you can add your own key-value backend.
  }
  gem.summary = 'Friendly GUI for managing your I18n translations'
  gem.homepage = 'https://github.com/kostia/riddick'
  gem.authors = ['Kostiantyn Kahanskyi']
  gem.email = %w[kostiantyn.kahanskyi@googlemail.com]
  gem.files = `git ls-files`.split("\n")
  gem.require_paths = %w[lib]
  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'i18n'
  gem.add_dependency 'redis'
  gem.add_dependency 'sinatra'
  gem.add_development_dependency 'activesupport', '>= 3.0.0'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webrat'
  gem.add_development_dependency 'yajl-ruby'
end
