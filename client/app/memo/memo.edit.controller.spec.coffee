'use strict'

describe 'Controller: MemoEditCtrl', ->
  
  # load the controller's module
  beforeEach module 'shiorisApp'
  beforeEach module 'socketMock'
  beforeEach module
    Auth:
      isLoggedInAsync: (callback) ->
        true
      getCurrentUser: () ->
        _id: 'test_user'
  for view in ['app/main/main.html', 'app/memo/memo-edit.html']
    beforeEach module view

  ctrl = undefined
  scope = undefined
  stateParams = undefined
  $httpBackend = undefined

  # Initialize the controller and a mock scope
  beforeEach inject (_$httpBackend_, $controller, $rootScope) ->
    $httpBackend = _$httpBackend_
    $httpBackend.whenGET '/api/users/test_user/memos/test_memo'
    .respond
      title: 'Memo A'
      content: 'Content A'
    
    scope = $rootScope.$new()
    stateParams = {id: 'test_memo'}
    ctrl = $controller 'MemoEditCtrl',
      $scope: scope
      $stateParams: stateParams

  it 'should attach a memo', ->
    $httpBackend.flush()
    expect(scope.memo.title).toEqual 'Memo A'

  it 'should add a memo', ->
    $httpBackend.expectPOST '/api/users/test_user/memos', 
      title: 'Title C'
      content: 'Content C'
    .respond 201
    scope.memo =
      title: 'Title C'
      content: 'Content C'
    scope.saveMemo()
    $httpBackend.flush() 

  it 'should upate a memo', ->
    $httpBackend.expectPUT '/api/users/test_user/memos/test_memo',
      title: 'Title C'
      content: 'Content C'
    .respond 200
    scope.memo =
      _id: 'test_memo'
      title: 'Title C'
      content: 'Content C'
    scope.saveMemo()
    $httpBackend.flush

  it 'should delete a memo', ->
    $httpBackend.expectDELETE '/api/users/test_user/memos/test_memo'
    .respond 200,
      title: 'Title C'
      content: 'Content C'
    scope.memo =
      _id: 'test_memo'
    scope.deleteMemo()
    $httpBackend.flush
