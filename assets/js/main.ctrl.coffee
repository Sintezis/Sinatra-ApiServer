(->
	angular
		.module "webTurnt"
		.controller "MainController", MainController

	MainController = () ->
		@vm = this

		console.log "MainController"


)()