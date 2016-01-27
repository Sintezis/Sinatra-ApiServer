class Response
	attr_accessor :data, :error
	
	def initialize args
		@request = args[:for]
		@type = args[:of]
		@model_name = @request.params[:model]
		@content = {}
		@error = nil
		@data = nil
	end

	def self.for type, request
		response = new :for => request, :of => type
		yield response
	end

	def prepare_response 
		send @type unless @type.nil?		
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
		@content = @data if @error.nil?
	end
	
	def login
		@content = @data if @error.nil?
	end

	def password_recovery
		@content = @data if @error.nil?
	end

	def logout
		@content = @data if @error.nil?
	end

	#Records Controller
	def all_records
		@content = @data if @error.nil?
	end

	def get_record
		@content = @data if @error.nil?
	end

	def create_record
		@content = @data if @error.nil?
	end

	def save_record
		@content = @data if @error.nil?
	end

	def delete_record
		@content = @data if @error.nil?
	end

	def sync_records
	end

end