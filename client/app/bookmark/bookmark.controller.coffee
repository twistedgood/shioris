'use strict'

angular.module 'shiorisApp'
.controller 'BookmarkCtrl', ($scope, $http, socket, Auth) ->

  $scope.bookmarks = [];
  userId = Auth.getCurrentUser()._id

  $http.get "/api/users/#{userId}/bookmarks"
  .success (bookmarks) ->
    $scope.bookmarks = bookmarks;
    socket.syncUpdates 'bookmark', $scope.bookmarks
  
  $scope.addBookmark = () ->
    unless $scope.bookmark.url?
      $http.post "/api/users/#{userId}/bookmarks",
        url: $scope.bookmark.url
        userId: userId
      .success () ->
        $scope.bookmark.url = ''

  $scope.deleteBookmark = (bookmark) ->
    id = bookmark._id
    $http.delete "/api/users/#{userId}/bookmarks/#{id}" 
 
  $scope.searchBookmark = () ->
    query = $scope.query
    $http.get "/api/users/#{userId}/bookmarks?q=#{query}"
    .success (bookmarks) ->
      $scope.bookmarks = bookmarks
 
