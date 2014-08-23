'use strict'

angular.module 'shiorisApp'
.controller 'MemoCtrl', ($scope, $state, $stateParams, $http, $timeout, socket, Auth) ->

  userId = Auth.getCurrentUser()._id

  if $stateParams.id?
    $http.get "/api/users/#{userId}/memos/#{$stateParams.id}"
    .success (memo) ->
      $scope.memo = memo;

