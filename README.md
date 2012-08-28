# Riddick

Friendly GUI for managing your I18n translations.

![Screenshot](http://timeworkers-assets.s3.amazonaws.com/riddick.png)

BIG FAT WARNING: It's not for production yet! Please wait till it get tests etc.

## Installation

```ruby
# Gemfile
gem 'riddick'

# config/routes.rb
require 'riddick/server'
MyApp::Application.routes.draw do
  mount Reddick::Server.new, at: 'riddick', as: 'riddick'
end

# app/views/layouts/application.html.erb
<%= link_to t('.translations'), :riddick %>
```

## Deployment

Normally your using a proxy server like NGinx or Apache.
Unfortunately the assets from a mounted Sinatra app will not be served for
they aren't in the `public` directory of your Rails app. Here is a workaround for a
deployment with Capistrano:

```ruby
# config/deploy.rb
namespace :deploy do
  task :cp_riddick_assets do
    target = File.join %W[#{release_path} public riddick]
    run "cp -r `cd #{release_path} && bundle show riddick`/lib/riddick/public #{target}"
  end
end

after :deploy do
  deploy.cp_riddick_assets
end
```

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
