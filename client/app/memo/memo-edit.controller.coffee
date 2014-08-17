'use strict'

angular.module 'shiorisApp'
.controller 'MemoEditCtrl', ($scope, $state, $stateParams, $http, $timeout, socket, Auth) ->

  userId = Auth.getCurrentUser()._id
  $scope.user = Auth.getCurrentUser()

  if $stateParams.id?
    $http.get "/api/users/#{userId}/memos/#{$stateParams.id}"
    .success (memo) ->
      $scope.memo = memo;

  $scope.saveMemo = () ->
    if $scope.memo._id?
      $http.put "/api/users/#{userId}/memos/#{$scope.memo._id}", $scope.memo
      .success () ->
        $scope.alert =
          msg: 'Done!'
          type: 'success'
        $timeout () ->
          $scope.alert = null
        , 3000
    else
      memo = 
        title: $scope.memo.title
        content: $scope.memo.content
      $scope.memo.userId = userId
      $http.post "/api/users/#{userId}/memos", memo
      .success (memo) ->
        $scope.memo = memo
        $scope.alert =
          msg: 'Done!'
          type: 'success'
        $timeout () ->
          $scope.alert = null
        , 3000

  $scope.deleteMemo = () ->
    $http.delete "/api/users/#{userId}/memos/#{$scope.memo._id}" 
      .success () ->
        $state.go 'memo-list'


