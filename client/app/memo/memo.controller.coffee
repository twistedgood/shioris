'use strict'

angular.module 'shiorisApp'
.controller 'MemoCtrl', ($scope, $state, $stateParams, $http, socket, Auth) ->

  userId = Auth.getCurrentUser()._id

  if $stateParams.id?
    $http.get "/api/users/#{userId}/memos/#{$stateParams.id}"
    .success (memo) ->
      $scope.memo = memo;

  $scope.saveMemo = () ->
    if $scope.memo._id?
      $http.put "/api/users/#{userId}/memos/#{$scope.memo._id}", $scope.memo
      .success () ->
    else
      memo = 
        title: $scope.memo.title
        content: $scope.memo.content
      $scope.memo.userId = userId
      $http.post "/api/users/#{userId}/memos", memo
      .success (memo) ->
        $scope.memo = memo

  $scope.deleteMemo = () ->
    $http.delete "/api/users/#{userId}/memos/#{$scope.memo._id}" 
      .success () ->
        $state.go 'memo-list'

