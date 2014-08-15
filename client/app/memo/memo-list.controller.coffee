'use strict'

angular.module 'shiorisApp'
.controller 'MemoListCtrl', ($scope, $state, $http, socket, Auth) ->

  userId = Auth.getCurrentUser()._id

  $http.get "/api/users/#{userId}/memos"
  .success (memos) ->
    $scope.memos = memos

  $scope.deleteMemo = (memo) ->
    $http.delete "/api/users/#{userId}/memos/#{memo._id}" 
    .success () ->
