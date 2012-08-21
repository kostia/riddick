require 'i18n'
require 'sinatra'

require 'riddick/backends'
require 'riddick/hash'
require 'riddick/version'

module Riddick
  class Server < Sinatra::Base
    Riddick::Backends.simple.send :init_translations

    helpers do
      def url(*parts)
        [request.script_name, parts].join('/').squeeze('/')
      end
    end

    get '/' do
      @predefined_translations = calculate_predefined_translations
      @custom_translations = calculate_custom_translations
      erb :index
    end

    post '/set' do
      key, value = params[:key], params[:value]
      if key && !key.empty? && value && !value.empty?
        locale, *parts = key.split('.')
        I18n.backend.store_translations locale, {parts.join('.') => value}, escape: false
      end
      redirect url('/')
    end

    get '/del' do
      key = params[:key]
      store.del key if key && !key.empty?
      redirect url('/')
    end

    private

    def calculate_predefined_translations
      Riddick::Backends.simple.send(:translations)[I18n.locale].riddick_normalize
    end

    def calculate_custom_translations
      keys = store.keys
      keys.any? ? Hash[keys.zip store.mget(keys)] : {}
    end

    def store
      Riddick::Backends.key_value.store
    end
  end
end
