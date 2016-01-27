require 'securerandom'

class Security
	attr_accessor :model, :user

	def initialize object
		@model = object[:model]
	end

	def parse_tokens env
		auth = env['HTTP_AUTHORIZATION']
		@hash = auth[/hash=([^,]*)/].gsub("hash=", "")
		#api_key env
	end

	def api_key env
		auth = env['HTTP_AUTHORIZATION']
		unless  auth.nil? 
			@api_key = auth[/apiKey=([^,]*)/].gsub("apiKey=", "")
			@api_key = @api_key.gsub('"', '')
		end
	end

	#user authentification
	def login email, password
		user_valid = false
		@user = @model.first(:email => email)
		unless @user.nil?
			user_valid = true if @user.password == password
		end
		return user_valid
	end

	def generate_token
		SecureRandom.hex(32)
	end

	def recovery_code
		SecureRandom.hex(6)
	end

	#request authentification
	def validate request 
		request_valid = false
		parse_tokens request.env
		@user = @model.first(:token => @hash)
		request_valid = true unless @user.nil?
		yield request_valid
	end

	private :parse_tokens, :api_key
end