require 'i18n'
require 'multi_json'
require 'redis'
require 'sinatra'

require 'riddick/backend'
require 'riddick/backend/key_value'
require 'riddick/backend/key_value/value'
require 'riddick/backend/redis'
require 'riddick/backend/redis/value'
require 'riddick/backend/simple'
require 'riddick/hash'
require 'riddick/version'

module Riddick
end
