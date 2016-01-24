class RecordsController < Sinatra::Base
	enable :method_override

	before do
		content_type :json

		Request.validate request do |valid|
			error 400 unless valid
		end

		model_object = Object.const_get('User')
		Security.new(:model => model_object).validate request do |valid|
			error 401 unless valid	
		end

		#Wrapping incoming request in custom object
		@api_request = Request.new(:for => {:request => request, :params => params}) 
	end

	helpers do
		def api_request
			@api_request
		end
	end

	#GET ALL RECORDS FOR MODEL
	get '/all/:model' do
		Response.for :all_records, api_request do |response|
			model = api_request.params[:model]
			all_records = Object.const_get(model).all()
			unless all_records.nil?
				response.data = all_records	
			else
				response.error = Error.code 1001 #invalid data request, or data missing?
			end
			response.submit
		end
	end

	#GET RECORD FROM MODEL
	get '/:model/:id' do
		Response.for :get_record, api_request do |response|
			model = api_request.params[:model]
			id = api_request.params[:id]
			record = Object.const_get(model).get(id) 
			unless record.nil?
				response.data = record
			else
				response.error = Error.code 1001 #invalid data request, or data missing?
			end
		end
	end

	#CREATE RECORD
	post '/create/:model' do
		Response.for :create_record, api_request do |response|
			model = api_request.params[:model]
			new_record = Object.const_get(model).new
			new_record.attributes = api_request.for :create_record
			if new_record.save 
				response.data = new_record
			else
				response.error 1002 #record not created, invalid data request, or sent data invalid 
			end
		end
	end

	#SAVE RECORD
	post '/save/:model/?:id?' do
		content_type :json
		Response.for :save_record, api_request do |response|
			model = api_request.params[:model]
			id = api_request.params[:id]
			if id.nil?
				record = Object.const_get(model).new
				record.attributes = api_request.for :create_record
			else
				record = Object.const_get(model).get(id)
				record.attributes = api_request.for :update_record
			end
			if record.save
				response.data = record
				response.submit
			else
				response.error 1003 #record not saved, invalid data request, or sent data invalid
			end
		end
	end
	
	#DELETE
	delete '/:model/:id' do
		content_type :json
		Response.for :delete_record, api_request do |response|
			model = api_request.params[:model]
			id = api_request.params[:]
			record = Object.const_get(model).get(id)
			if record.destroy
				response.data = {:deleted => true}
			else	
				response.error Error.code 1004 #record not deletes, data missing, or invalid data request
			end
			response.submit
		end
	end

	# SYNC RECORDS REQUEST
	post '/sync/:model' do
		Response.for :sync_records, api_request do |response|
		end
	end 

end

