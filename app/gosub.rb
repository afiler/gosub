require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'slim'

class Gosub < Sinatra::Base
  register Sinatra::AssetPipeline

  set :public_folder, File.dirname(__FILE__) + '/../public'

  get '/' do
    slim :index
  end
end
