require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'slim'

class Gosub < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    slim :index
  end
end
