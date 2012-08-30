# Riddick

Friendly GUI for managing your I18n translations.

![Screenshot](http://timeworkers-assets.s3.amazonaws.com/riddick.png)

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
  mount Reddick::Server.new, at: 'riddick', as: 'riddick'
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

## Configuration

Will follow soon...

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
