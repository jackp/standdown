###*
 * Member Module Controller
###
angular.module 'standdown.member', ['ui.router']

# Routing
.config ($stateProvider) ->
	$stateProvider
		.state 'member',
			url: '/member/:id'
			templateUrl: 'member/member.html'
			controller: "MemberCtrl"

# Controller
.controller 'MemberCtrl', ($scope) ->
	console.log 'Member Controller'