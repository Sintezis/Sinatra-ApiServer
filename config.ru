#load sinatra
require 'rubygems'
require 'sinatra/base'
require 'sinatra/contrib'

#require global dependencies
require 'data_mapper'
require 'json'
require 'houston'

#load api config
@config = YAML::load_file(File.join(__dir__, 'api_config.yaml'))

#load controllers
Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file}

#load models
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file}

#load managers
Dir[File.dirname(__FILE__) + '/managers/*.rb'].each {|file| require file}

#Setup Database
if ENV['RACK_ENV'] == 'development' 
	DataMapper.setup(:default, "postgres://#{@config['db_user']}:#{@config['db_user_password']}@127.0.0.1/#{@config['db_name']}")
elsif ENV['RACK_ENV'] == 'heroku'
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end
DataMapper.finalize.auto_upgrade!

#Setup Apple Push Notifications
if ENV['RACK_ENV'] == 'production'
	APN = Houston::Client.production
	APN.certificate = File.read('')
else 
	APN = Houston::Client.development
	APN.certificate = File.read('apn/apns-dev.pem')
end

#map controllers
map('/api/records') 		 {run RecordsController}
map('/api/authenticate') {run AuthenticationController}
map('/') 								 {run WebController}

