(->
	angular
		.module "apiServer"
		.controller "MainController", MainController

	MainController = () ->
		@vm = this

		console.log "MainController"


)()