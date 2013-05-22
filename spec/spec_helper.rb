require 'rake'
require 'webrat'
require 'yajl'

include Rake::DSL

load 'lib/riddick.rb'

RSpec.configure do |config|
  config.include Webrat::Matchers
end
