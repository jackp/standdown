###*
 * Settings Module Controller
###
angular.module 'standdown.settings', ['ui.router']

# Routing
.config ($stateProvider) ->
	$stateProvider
		.state 'settings',
			url: '/settings'
			templateUrl: 'settings/settings.html'
			controller: "SettingsCtrl"

# Controller
.controller 'SettingsCtrl', ($scope) ->
	console.log 'Settings Controller'