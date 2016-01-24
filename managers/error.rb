class Error
	attr_accessor :errors
	
	def initialize code
			@code = code
			@errors = [
			{
				:code => 1001,
				:msg => "Invalid data request, or data missing."
			},
			{
				:code => 1002,
				:msg => "Record not created, invalid data request, or sent data invalid."
			},
			{
				:code => 1003,
				:msg => "Record not saved, invalid data request, or sent data invalid."
			},
			{
				:code => 1004,
				:msg => "Record not deletes, data missing, or invalid data request."
			},
			{
				:code => 1005,
				:msg => "Provided email is in use by another user."
			},
			{
				:code => 1006,
				:msg => "There is no user with provided email in our records."
			}
		]
	end

	#INSTANCE METHODS
	def get 
		@errors.find {|error| error[:code] == @code}
	end

	#STATIC METHODS
	def self.code int
		Error.new int
	end

end