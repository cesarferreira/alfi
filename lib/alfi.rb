module Alfi
end

require 'json'
require 'net/http'
require 'uri'
require 'colorize'
require 'alfi/providers'
require 'alfi/providers/base'

Dir["#{File.dirname(__FILE__)}/alfi/**/*.rb"].each { |file| require file }
