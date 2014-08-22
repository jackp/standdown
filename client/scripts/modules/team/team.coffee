###*
 * Team Module Controller
###
angular.module 'standdown.team', ['ui.router']

# Routing
.config ($stateProvider) ->
	$stateProvider
		.state 'team',
			url: '/team/:id'
			templateUrl: 'team/team.html'
			controller: "TeamCtrl"

# Controller
.controller 'TeamCtrl', ($scope) ->
	console.log 'Team Controller'