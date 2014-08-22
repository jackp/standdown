###*
 * Standdown - Main Module
###

angular.module 'standdown', [
	'ui.router',
	'restangular',
	'directives.semantic',
	'standdown.templates',
	'standdown.landing',
	'standdown.member',
	'standdown.organization',
	'standdown.settings',
	'standdown.team'
]

# Application Configuration
.config ($locationProvider, RestangularProvider) ->
	# Use HTML5Mode
	$locationProvider.html5Mode(true).hashPrefix('#')

	# Restangular Configuration
	RestangularProvider.setBaseUrl('/api/v1')

# Runtime Logic
.run ($rootScope) ->
	console.log 'Standdown Started'