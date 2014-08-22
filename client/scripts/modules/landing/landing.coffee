###*
 * Landing Module Controller
###
angular.module 'standdown.landing', ['ui.router', 'Satellizer']

# Routing
.config ($stateProvider) ->
	$stateProvider
		.state 'landing',
			url: '/'
			templateUrl: 'landing/landing.html'
			controller: "LandingCtrl"

# Controller
.controller 'LandingCtrl', ($scope, $auth) ->
	console.log 'Landing Controller'

