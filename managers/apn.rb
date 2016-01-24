class APN

	attr_accessor :badge, :sound
	
	class << self
		def manager
			@manager ||= new
		end
		private :new
	end

 	def friend_request
 		@msg = "#{Account.get(@from).username} wants to add you to his chat list!"
 		@type = 'add'
 	end

 	def poke
 		@msg = "@#{Account.get(@from).username} want's to talk to you!",
 		@type = 'poke'
 	end

 	def notify data
 		@device_token = Account.get(data[:friend]).user.device_token
 		@from = data[:for].id
 		@to = data[:friend]
 		@badge = 1
 		@sound = 'default'
 	end

 	def submit type
 		send type
 		#production
		#APNS.host = 'gateway.push.apple.com'

		#development
		APNS.host = 'gateway.sandbox.push.apple.com'

		APNS.pem  = 'apn/apns-dev.pem'
    APNS.port = 2195
    
 		APNS.send_notification(
			@device_token,
			:alert => @msg,
			:badge => @badge,
			:sound => @sound,
			:from => @from,
			:to 	=> @to,
			:type => @type
		)	
 	end

 	private :friend_request, :poke

end
