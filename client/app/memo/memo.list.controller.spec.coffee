'use strict'

describe 'Controller: MemoListCtrl', ->
  
  # load the controller's module
  beforeEach module 'shiorisApp'
  beforeEach module 'socketMock'
  beforeEach module
    Auth:
      isLoggedInAsync: (callback) ->
        true
      getCurrentUser: () ->
        _id: 'test_user'
  for view in ['app/main/main.html', 'app/memo/memo-list.html']
    beforeEach module view

  ctrl = undefined
  scope = undefined
  $httpBackend = undefined
  socket = undefined

  # Initialize the controller and a mock scope
  beforeEach inject (_$httpBackend_, $controller, $rootScope, _socket_) ->
    $httpBackend = _$httpBackend_
    $httpBackend.whenGET '/api/users/test_user/memos'
    .respond [
      { title: 'Memo A', content: 'Content A'}
      { title: 'Memo B', content: 'Content B'}
    ]
    
    socket = _socket_
    scope = $rootScope.$new()
    ctrl = $controller 'MemoListCtrl',
      $scope: scope

  afterEach () ->
    $httpBackend.verifyNoOutstandingExpectation()

  it 'should attach a list of memo', ->
    $httpBackend.flush()
    expect(scope.memos.length).toEqual 2

  it 'should delete a memo', ->
    $httpBackend.expectDELETE '/api/users/test_user/memos/test_memo'
    .respond 204
    scope.deleteMemo _id: 'test_memo'
    $httpBackend.flush



