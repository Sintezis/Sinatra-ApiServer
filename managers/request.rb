class Request 
	attr_accessor :body, :params
	
	def initialize args
		@data = args[:for][:request]
		@params = args[:for][:params]

		if @data.request_method == 'POST'
			@data.body.rewind
			@body = JSON.parse(@data.body.read)
		end
	end	

	### Static Methods
	def self.validate req
		request_valid = true
		request = new :for => {:request => req, :params => nil}
		request_valid = false unless request.is_valid_media_type?
		yield request_valid
	end

	### Instance Methods
	def is_valid_media_type?
		@data.media_type == 'application/json'
	end

	def is_valid_json?
		unless @data.request_method == 'GET'
		  begin
		    @body = JSON.parse(@data.body.read)
		    return true
		  rescue JSON::ParserError => e
		    return false
		  end
		end
	end

	def for type
		send type
	end

	def create_record
		return @body
	end

	def update_record 
		return @body
	end

	def register
		return @body
	end

end