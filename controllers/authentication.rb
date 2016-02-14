class AuthenticationController < Sinatra::Base
	enable :method_override

	before do
		content_type :json
		Request.validate request do |valid|
			error 400 unless valid
		end

		#set model name where all the authetication data for a users is set
		model_name = 'User'
		model_object = Object.const_get(model_name)
		@security = Security.new(:model => model_object) 
	end

	helpers do
		def api_request
			#Wrapping incoming request in custom object
			Request.new(:for => {:request => request, :params => params}) 
		end

		def security
			@security
		end
	end

	post '/register' do
		Response.for :register, api_request do |response|
			email = api_request.body["email"]
			record = security.model.first(:email => email)
			if record.nil?
				#provided email is not in use, user can register with it
				record = security.model.new
				record.attributes = api_request.for :register
				record.token = security.generate_token
				if record.save
					response.data = record
				else
					response.error = Error.code 1002 #record not created, invalid data request, or sent data invalid 
				end
			else
				response.error = Error.code 1005 #provided email is in use by another user
			end
			response.submit
		end
	end

	post '/login' do
		Response.for :login, api_request do |response|
			email = api_request.body["email"]
			password = api_request.body["password"]
			login_valid = security.login email, password 
			if login_valid 
				security.user.token = security.generate_token
				security.user.save
				response.data = {:logged_in => true, :token => security.user.token, :user_id => security.user.id} 
			else
				response.error = Error.code 1006 #invalid email and password combination
			end
			response.submit
		end
	end

	post '/recover/password' do
		Response.for :password_recovery, api_request do |response|
			email = api_request.body["email"]
			record = security.model.first(:email => email)
			unless record.nil?
				code = security.recovery_code
				#send recover email with generated recovery code to specified email
				response.data = {:email_sent => true}
			else
				response.error = Error.code 1007 #there is no user with provided email in our records
			end
			response.submit
		end
	end

	post 'recover/account' do
		Response.for :account_recovery, api_request do |response|
			record = security.model.first(:recovery_code => api_request.body["code"])
			unless record.nil?
				response.data = {:valid_user => true, :user => record}
			else
				response.error = Error.code 1009 #invalid recovery code
			end
		end
		response.submit
	end

	post 'change/password' do

	end

	put '/logout/:id' do
		Response.for :logout, api_request do |response|
			id = api_request.params[:id]
			record = security.model.get(id)
			unless record.nil?
				record.token = nil
				response.data = {:loged_out => true}
			else
				response.error Error.code 1001 #invalid data request, or data missing?
			end
			response.submit
		end
	end

end