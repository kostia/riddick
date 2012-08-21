Riddick
=======

Riddick is a simple Sintra based GUI for Redis-I18n-backend.
It provides a list of preconfigured translations (via YAML-backend).
Also you can add your translations to Redis-backend.

BIG FAT WARNING: It's not for production yet! Please wait till it get tests etc.

```ruby
# Gemfile
gem 'riddick'

# config/routes.rb
require 'riddick/server'
MyApp::Application.routes.draw do
  mount Reddick::Server.new, at: 'riddick', as: 'riddick'
end

# app/views/layouts/application.html.erb
<%= link_to 'Riddick', :riddick %>
```

