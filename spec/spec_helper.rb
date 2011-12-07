ENV["RAILS_ENV"] = "test"
$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path('../lib', __FILE__)

require 'bundler/setup'
require 'cover_me'
require 'rspec'
require 'tane'

CoverMe.config do |c|
end

RSpec.configure do |config|
  # Haven't decided yet what to configure here
end
