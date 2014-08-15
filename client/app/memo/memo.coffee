'use strict'

angular.module 'shiorisApp'
.config ($stateProvider) ->
  $stateProvider
    .state 'memo-list',
      url: '/memo'
      templateUrl: 'app/memo/memo-list.html'
      controller: 'MemoListCtrl'
      authenticate: true
    .state 'memo',
      url: '/memo/:id'
      templateUrl: 'app/memo/memo.html'
      controller: 'MemoCtrl'
      authenticate: true

