# Riddick

[![Build Status](https://travis-ci.org/kostia/riddick.png)](https://travis-ci.org/kostia/riddick)
[![Code Climate](https://codeclimate.com/github/kostia/riddick.png)](https://codeclimate.com/github/kostia/riddick)

Friendly GUI for managing your I18n translations.

## I18n + Redis + GUI = Riddick

By default it uses Redis as I18n backend for translations, but you can add your own key-value backend.

![Screenshot](https://raw.github.com/kostia/riddick/master/screenshot.png)

## Installation

Bundle Riddick gem:
```ruby
# Gemfile
gem 'riddick'
```

Mount Riddick server:
```ruby
# config/routes.rb
require 'riddick/server'
MyApp::Application.routes.draw do
  mount Riddick::Server.new, at: 'riddick', as: 'riddick'
end
```

Add a link to the GUI:
```ruby
# app/views/layouts/application.html.erb
<%= link_to t('.translations'), :riddick %>
```

Tell I18n to use key-value-backend (if you haven't already):
```ruby
#  config/initializers/i18n.rb
I18n.backend = I18n::Backend::Chain.new I18n::Backend::KeyValue.new(Redis.new), I18n.backend
```

## Configuration & Customization

### Localizing the Riddick GUI

You can also change the translations of Riddick GUI. Following keys can be changed:
```yaml
riddick:
  head:
    title: 'Welcome to Riddick!'
  nav:
    brand: 'Riddick'
    all: 'All translations'
    my: 'My translations'
    default: 'Default translations'
  form:
    select:
      placeholder: 'en.greeting'
    button: 'Change'
    textarea:
      placeholder: 'Hello World!'
  table:
    header:
      path: 'Path'
      translation: 'Translation'
      actions: 'Actions'
    popover:
      my: 'My translation'
      default: 'Default translation'
    edit:
      my: 'Edit'
      default: 'Edit'
    delete: 'Delete'
    confirm: 'Are you sure?'
  notice:
    empty: 'You have no translations yet.'
    set:
      success: 'Translation successfully stored!'
      error: 'Error: either path or translation is empty!'
    del:
      success: 'Translation successfully deleted!'
      error: 'Error: no such key or key empty!'
  truncation: '...'
```

For example to change the page title of the GUI on the German page:
```yaml
# config/locales/riddick.de.yml
de:
  riddick:
    head:
      title: 'Willkommen bei Riddick!'
```

### Changing backends

By default Riddick will try to guess which backends to use, assuming your using a chained backend.

For the key-value backend it will ask the chain backend for it's backends with `I18n.backend.backends`
and will use the first one of type `I18n::Backends::KeyValue`.

For the fallback backend it will ask the chain backend for it's backends with `I18n.backend.backends`
and will use the first one of type `I18n::Backends::Simple`.

You can change this behavior by setting one or both backends (or even the chain explicitely):
```ruby
# config/initializers/riddick.rb
Riddick::Backends.chain = MyChainBackend
Riddick::Backends.simple = MySimpleBackend
Riddick::Backends.key_value = MyKeyValueBackend
```

* `MyChainBackend` can be any backend which is kind of `I18n::Backend::Chain`.
* `MySimpleBackend` can be any backend which is kind of `Riddick::Backends::Simple`.
* `MyKeyValueBackend` can be any backend which is kind of `Riddick::Backends::KeyValue`.

Example:
```ruby
MySimpleBackend = Riddick::Backends::Simple.new I18n.backend
MyKeyValueBackend = Riddick::Backends::KeyValue.new I18n::Backend::KeyValue.new(Redis.new)
```

You can also write your own backends by subclassing apropriate backend from Riddick and
adding to it needed methods (see RDoc for details).

WARNING: Custom backends feature is still under development. You should NOT use it unless you
want to help me to develop it.

Example:
```ruby
class MyRedisBackend < Riddick::Backends::Redis
  def delete_translation(k)
    Rails.logger.info "Translation #{k} deleted"
    super
  end
end
```

If you want to write a completely different backend, you can subclass `Riddick::Backends::KeyValue`.
In this case you can also implement the appropriate `Value` class if needed (see RDoc for details).

Example:
```ruby
class ActiveRecordBackend < Riddick::Backends::KeyValue
  def delete_translation(k)
    MyModel.find_by_key(k).destroy
  end

  def translations
    hash = {}
    MyModel.all.pluck(:key, :value).map { |k, v| hash[k] = ActiveRecordBackend::Value.new v }
    hash
  end

  class Value < Riddick::Backends::KeyValue::Value
    def initialize(string)
      @object = MultiJson.decode string
    end

    def to_s
      @object.inspect
    end
  end
end
```

## Troubleshooting

### JSON decoding errors

We recommend you to switch to YAJL gem:
```ruby
# Gemfile
gem 'yajl-ruby', require: 'yajl/json_gem'
```

__Details__: I18n uses MultiJson gem internally to encode / decode translation objects in key-value-backends.
Unfortunately the default JSON gem is too strict about this and doesn't allow to decode plain strings,
which is essential for a key-value-based backend.

### No assets in production environment

Just copy assets from Riddick to you app's public directory:
```ruby
# config/deploy.rb:
after :deploy do
  target = File.join %W[#{release_path} public riddick]
  run "cp -r `cd #{release_path} && bundle show riddick`/lib/riddick/public #{target}"
end
```

__Details__: Normally your using a proxy server like NGinx or Apache in front of your app.
Unfortunately the assets from a mounted Sinatra app will not be served because
they aren't in the `public` directory of your app.

### You are using redis not only for storing translations

If your are using redis to store other stuff you can separate your I18n translations in namespace. Please use redis-namespace gem.
```ruby
# Gemfile
gem 'redis-namespace'
```

Change your configuration in i18n.rb
```ruby
#  config/initializers/i18n.rb
I18n.backend = I18n::Backend::Chain.new I18n::Backend::KeyValue.new(Redis::Namespace.new(:riddick)), I18n.backend
```

Your I18n translations will be stored in `riddick` namespace.

## Internals

Take a look at http://railscasts.com/episodes/256-i18n-backends

## License

Copyright (c) 2012 Kostiantyn Kahanskyi

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
