angular.module('loomioApp').directive 'pollCommonFormFields', ($translate, Records, Session, AbilityService, EmojiService) ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/form_fields/poll_common_form_fields.html'
  controller: ($scope) ->
    $scope.availableGroups = ->
      _.filter Session.user().groups(), (group) ->
        AbilityService.canStartPoll(group)

    $scope.showGroupSelect = $scope.poll.isNew()

    # NB; this overrides the restoreDraft() function applied in draft_service
    $scope.restoreDraft = ->
      return unless $scope.poll.group()? and $scope.poll.isNew()
      $scope.poll.restoreDraft()

    $scope.titlePlaceholder = ->
      $translate.instant("poll_#{$scope.poll.pollType}_form.title_placeholder")

    $scope.detailsPlaceholder = ->
      $translate.instant("poll_#{$scope.poll.pollType}_form.details_placeholder")

    $scope.changeGroup = ->
      $scope.poll.notified = _.reject $scope.poll.notified, (notified) ->
        notified.type == "FormalGroup"
      if $scope.poll.group()
        Records.searchResults.fetchNotified($scope.poll.group().name).then (data) ->
          $scope.poll.notified.push(data[0]) if data.length
