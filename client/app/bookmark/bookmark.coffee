'use strict'

angular.module('shiorisApp').config ($stateProvider) ->
  $stateProvider.state 'bookmark',
    url: '/bookmark'
    templateUrl: 'app/bookmark/bookmark.html'
    controller: 'BookmarkCtrl'
