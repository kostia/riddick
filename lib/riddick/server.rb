require 'i18n'
require 'sinatra'

require 'riddick/backends'
require 'riddick/hash'
require 'riddick/version'

module Riddick
  class Server < Sinatra::Base
    Riddick::Backends.simple.init_translations

    helpers do
      def url(*parts)
        [request.script_name, parts].join('/').squeeze '/'
      end

      def root_url
        url '/'
      end

      def default_url
        url 'default'
      end

      def my_url
        url 'my'
      end

      def set_url
        url 'set'
      end

      def del_url(k)
        url('del') + "?k=#{URI.escape k}"
      end

      def truncate(v, l = 30)
        s = v.to_s
        s.size > l ? s.first(l) + '...' : s
      end
    end

    get '/' do
      predefined = Riddick::Backends.simple.translations
      custom = Riddick::Backends.key_value.translations
      @translations = predefined.merge custom
      erb :index
    end

    get '/default' do
      @translations = Riddick::Backends.simple.translations
      erb :index
    end

    get '/my' do
      @translations = Riddick::Backends.key_value.translations
      erb :index
    end

    post '/set' do
      k, v = params[:k], params[:v]
      if k && v && !k.empty? && !v.empty?
        Riddick::Backends.store_translation k, v
        session[:flash_success] = 'Translation successfully stored!'
      else
        session[:flash_error] = 'Error: either path or translation is empty!'
      end
      redirect my_url
    end

    get '/del' do
      k = params[:k]
      if k && !k.empty?
        Riddick::Backends.delete_translation k
        session[:flash_success] = 'Translation successfully deleted!'
      else
        session[:flash_error] = 'Error: no such key or key not found!'
      end
      redirect(request.referer || root_url)
    end
  end
end
