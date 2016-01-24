(->
	'use strict';
	loadModules = [
		"ngRoute"
	]

	angular
		.module "apiServer", loadModules	
		.config ($routeProvider)->
			$routeProvider
				.when "/", {
					templateUrl: "templates/index"
				}
				.when '/home', {
					controller: "MainController",
					contrllerAs: "main"
					templateUrl: "templates/home"
				}
)()