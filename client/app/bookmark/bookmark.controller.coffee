'use strict'

angular.module('shiorisApp').controller 'BookmarkCtrl', ($scope, $http, socket, Auth) ->
  $scope.bookmarks = [];
  $scope.message = 'Hello'
  userId = Auth.getCurrentUser()._id

  $http.get("/api/users/#{userId}/bookmarks").success (bookmarks) ->
    $scope.bookmarks = bookmarks;
    socket.syncUpdates 'bookamrk', $scope.bookmark
  
  $scope.addBookmark = () ->
    unless $scope.bookmark.url is ''
      $http.post("/api/users/#{userId}/bookmarks", {
        url: $scope.bookmark.url,
        userId: userId
      }).success () ->
        $scope.bookmark.url = ''

  $scope.deleteBookmark = (bookmark) ->
    id = bookmark._id
    $http.delete("/api/users/#{userId}/bookmarks/#{id}")
 
  $scope.searchBookmark = () ->
    query = $scope.query
    $http.get("/api/users/#{userId}/bookmarks?q=#{query}")
 
