require 'riddick'

module Riddick
  # Main Riddick GUI.
  # Can be run as a stand-alone app or mounten into another Rails app.
  # All translations cam be changed (see README for further details).
  # To change the templates, subclass Riddick::Server and set change the view path.
  class Server < Sinatra::Base
    # I18n load the fallback translations lazy.
    # To correctly display the default translations, we have to ensure they are loaded on startup.
    Riddick::Backends.simple.init_translations

    helpers do
      # Build an internal URL.
      def url(*parts)
        [request.script_name, parts].join('/').squeeze '/'
      end

      # URL for the main interface.
      def root_url
        url '/'
      end

      # URL for displaying default translations only.
      def default_url
        url 'default'
      end

      # URL for displaying custom translations only.
      def my_url
        url 'my'
      end

      # URL for storing a translation.
      def set_url
        url 'set'
      end

      # URL for deleting a translation.
      def del_url(k)
        url('del') + "?k=#{URI.escape k}"
      end

      # Shortcut for namepspaces localization
      def t(path, default = nil)
        I18n.t "riddick.#{path}", default: default
      end

      # Truncate a string with default length 30. Truncation string is '...' by default
      # and can be changed by changing the appropriate translation (see README for further details).
      def truncate(v, l = 30)
        s = v.to_s
        s.size > l ? s.first(l) + t('truncation', '...') : s
      end
    end

    # Render index page with all translations.
    get '/' do
      predefined = Riddick::Backends.simple.translations
      custom = Riddick::Backends.key_value.translations
      @translations = predefined.merge custom
      erb :index
    end

    # Render index page with default translations only.
    get '/default' do
      @translations = Riddick::Backends.simple.translations
      erb :index
    end

    # Render index page with custom translations only.
    get '/my' do
      @translations = Riddick::Backends.key_value.translations
      erb :index
    end

    # Store a translation.
    # Params (both have to be non-empty values):
    #   k - path for the translation (including the locale).
    #   v - the translation itself.
    post '/set' do
      k, v = params[:k], params[:v]
      if k && v && !k.empty? && !v.empty?
        Riddick::Backends.store_translation k, v
        session[:flash_success] = t('notice.set.success', 'Translation successfully stored!')
      else
        session[:flash_error] = t('notice.set.error', 'Error: either path or translation is empty!')
      end
      redirect my_url
    end

    # Delete a translation.
    # Params (have to be a non-empty value):
    #   k - path for the translation (including the locale).
    get '/del' do
      k = params[:k]
      if k && !k.empty?
        Riddick::Backends.delete_translation k
        session[:flash_success] = t('notice.del.success', 'Translation successfully deleted!')
      else
        session[:flash_error] = t('notice.del.error', 'Error: no such key or key empty!')
      end
      redirect(request.referer || root_url)
    end
  end
end
