#load sinatra
require 'sinatra/base'
require 'sinatra/contrib'

#require global dependencies
require 'data_mapper'
require 'json'

#load controllers
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file}

#load models
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file}

#load managers
Dir[File.dirname(__FILE__) + '/managers/*.rb'].each {|file| require file}

#Setup DB config
if ENV['RACK_ENV'] == 'development' 
	DataMapper.setup(:default, 'postgres://turnt:turnt@127.0.0.1/turnt')
elsif ENV['RACK_ENV'] == 'heroku'
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end
DataMapper.finalize.auto_upgrade!

#map controllers
map('/api/records') 		 {run RecordsController}
map('/api/authenticate') {run AuthenticationController}
map('/') 								 {run WebController}

