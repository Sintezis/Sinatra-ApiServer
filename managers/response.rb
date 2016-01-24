class Response
	attr_accessor :data, :error
	
	def initialize args
		@request = args[:for]
		@type = args[:of]
		@model_name = @request.params[:model]
		@content = {}
		@error = nil
	end

	def self.for type, request
		response = new :for => request, :of => type
		yield response
	end

	def prepare_response 
		send @type		
	end

	def set_error 
		@content["errors"] = @error.get
	end

	def submit
		set_error unless @error.nil?
		prepare_response 
		@content.to_json
	end

	#Authentication Controller
	def register 
		@content = @data
	end
	
	def login
		@content = @data
	end

	def password_recovery
		@content = @data
	end

	def logout
		@content = @data
	end

	#Records Controller
	def all_records
		@content = @data
	end

	def get_record
		@content = @data
	end

	def create_record
		@content = @data
	end

	def save_record
		@content = @data
	end

	def delete_record
		@content = @data
	end

	def sync_records
	end

end