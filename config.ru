require 'rubygems'
require 'bundler'
Bundler.setup


require 'sprockets'
map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  environment.append_path 'vendor/javascripts'
  environment.append_path 'app/assets/stylesheets'
  environment.append_path 'bower_components'
  run environment
end

require './app/gosub.rb'
run Gosub