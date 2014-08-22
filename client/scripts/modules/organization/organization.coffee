###*
 * Organization Module Controller
###
angular.module 'standdown.organization', ['ui.router']

# Routing
.config ($stateProvider) ->
	$stateProvider
		.state 'organization',
			url: '/organization/:id'
			templateUrl: 'organization/organization.html'
			controller: "OrganizationCtrl"

# Controller
.controller 'OrganizationCtrl', ($scope) ->
	console.log 'Organization Controller'