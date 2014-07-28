'use strict'

angular.module('shiorisApp').controller 'BookmarkCtrl', ($scope, $http, socket, Auth) ->
  $scope.bookmarks = [];
  $scope.message = 'Hello'

  $http.get('/api/bookmarks?u=' + Auth.getCurrentUser()._id).success (bookmarks) ->
    $scope.bookmarks = bookmarks;
    #socket.syncUpdates 'bookamrk', $scope.bookmark
  
  $scope.addBookmark = () ->
    unless $scope.bookmark.url is ''
      $http.post('/api/bookmarks', {
        url: $scope.bookmark.url,
        userId: Auth.getCurrentUser()._id
      }).success () ->
        $scope.bookmark.url = ''

  $scope.deleteBookmark = (bookmark) ->
    $http.delete('/api/bookmarks/' + bookmark._id)

