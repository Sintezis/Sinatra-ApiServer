#api.rb
require 'haml'
require "coffee-script"
require 'sinatra/assetpack'


class WebController < Sinatra::Base
	set :root, File.dirname(File.dirname(__FILE__))
	# set :public_folder, '/var/www/app/public'
	# set :views, '/var/www/app/views'

	register Sinatra::Reloader
	register Sinatra::AssetPack

	assets do
		serve '/js',   from: 'assets/js'
		serve '/css',  from: 'assets/css'
		serve '/imgs', from: 'assets/imgs' 
		
		js :main, [
      '/js/main.js',
    ]

    css :main, [
      '/css/main.css'
    ]

    js :ngApp, [
    	'/js/client.js',
    	'/js/main.ctrl.js',
    ]

    # js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    # css_compression :simple   # :simple | :sass | :yui | :sqwish
	end

	# fetch angular templates
	get '/templates/:filename' do
		haml params[:filename].to_sym
	end

	get "/" do 
		haml :index
	end	
end





