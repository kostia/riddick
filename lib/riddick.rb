require 'i18n'
require 'multi_json'
require 'redis'
require 'sinatra'

require 'riddick/backends'
require 'riddick/backends/key_value'
require 'riddick/backends/key_value/value'
require 'riddick/backends/redis'
require 'riddick/backends/redis/value'
require 'riddick/backends/simple'
require 'riddick/hash'
require 'riddick/version'

module Riddick
end
