###*
 * Semantic UI Javascript, but in Angular!
###
angular.module('directives.semantic', [])

.directive 'modal', ($document) ->
	restrict: "E"
	replace: true
	transclude: true
	scope:
		open: '='
		size: '@'
	template: """
						<div class="ui dimmer page transition fade in" ng-class="{ active: open }">
							<div class="ui test {{size}} modal transition fade in visible"></div>
						</div>
						"""
	link: (scope, element, attrs, controller, transclude) ->
		# Manually add close icon to transcluded html to not break semantic classes
		# due to the transclude div
		element.find('.modal').html(transclude()).prepend('<i class="close icon"></i>')

		# Close modal on click of close button or ESC
		close = () ->
			scope.open = false
			scope.$apply()

		element.find('.close.icon').on 'click', close

		$document.on 'keydown', (e) ->
			if e.which is 27
				close()

		scope.$on "$destroy", ->
			$document.off 'keydown'