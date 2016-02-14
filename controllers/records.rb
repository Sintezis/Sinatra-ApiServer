class RecordsController < Sinatra::Base
	enable :method_override

	helpers do
		def api_request
			#Wrapping incoming request in custom object
			Request.new(:for => {:request => request, :params => params})
		end

		def model_name
			api_request.params["model"].capitalize
		end

		def valid_model?
			Object.const_defined? model_name
		end
	end

	before do
		content_type :json

		Request.validate request do |valid|
			error 400 unless valid
		end

		model_object = Object.const_get('User')
		# Security.new(:model => model_object).validate request do |valid|
		# 	error 401 unless valid	
		# end 
	end

	#GET ALL RECORDS FOR MODEL
	get '/all/:model' do
		Response.for :all_records, api_request do |response|
			if valid_model?
				all_records = Object.const_get(model_name).all()
				unless all_records.nil?
					response.data = all_records	
				else
					response.error = Error.code 1001 #invalid data request, or data missing?
				end
			else
				response.error = Error.code 1008 #invalid model request
			end
			response.submit
		end
	end

	#GET RECORD FROM MODEL
	get '/:model/:id' do
		Response.for :get_record, api_request do |response|
			id = api_request.params[:id]
			if valid_model?
				record = Object.const_get(model_name).get(id) 
				unless record.nil?
					response.data = record
				else
					response.error = Error.code 1001 #invalid data request, or data missing
				end
			else
				response.error = Error.code 1008 #invalid model request
			end
			response.submit
		end
	end

	#CREATE RECORD
	post '/create/:model' do
		Response.for :create_record, api_request do |response|
			if valid_model?
				new_record = Object.const_get(model_name).new
				new_record.attributes = api_request.for :create_record
				if new_record.save 
					response.data = new_record
				else
					response.error = Error.code 1002 #record not created, invalid data request, or sent data invalid 
				end
			else
				response.error = Error.code 1008 #invalid model request
			end
			response.submit
		end
	end

	#SAVE RECORD
	post '/save/:model/?:id?' do
		Response.for :save_record, api_request do |response|
			id = api_request.params[:id]
			if valid_model?
				if id.nil?
					record = Object.const_get(model_name).new
				else
					record = Object.const_get(model_name).get(id)
				end
				unless record.nil?
					record.attributes = api_request.for :update_record
					if record.save
						response.data = record
					else
						response.error = Error.code 1003 #record not saved, invalid data request, or sent data invalid
					end
				else
					response.error = Error.code 1001 #invalid data request, or data missing
				end
			else
				response.error = Error.code 1008 #invalid model request
			end
			response.submit
		end
	end
	
	#DELETE
	delete '/:model/:id' do
		Response.for :delete_record, api_request do |response|
			id = api_request.params[:id]
			if valid_model?
				record = Object.const_get(model_name).get(id)
				unless record.nil?
					if record.destroy
						response.data = {:deleted => true}
					else	
						response.error = Error.code 1004 #record not deletes, data missing, or invalid data request
					end
				else
					response.error = Error.code 1001 #invalid data request, or data missing
				end
			else
				response.error = Error.code 1008 #invalid model request
			end
			response.submit
		end
	end

	# SYNC RECORDS REQUEST
	post '/sync/:model' do
		Response.for :sync_records, api_request do |response|
			if valid_model?

			else
				response.error = Error.code 1008 #invalid model request
			end
			response.submit
		end
	end 

end

