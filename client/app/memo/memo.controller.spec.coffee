'use strict'

describe 'Controller: MemoCtrl', ->
  
  # load the controller's module
  beforeEach module 'shiorisApp'
  beforeEach module 'socketMock'
  beforeEach module
    Auth:
      isLoggedInAsync: (callback) ->
        true
      getCurrentUser: () ->
        _id: 'test_user'
  for view in ['app/main/main.html', 'app/memo/memo.html']
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
    ctrl = $controller 'MemoCtrl',
      $scope: scope
      $stateParams: stateParams

  it 'should attach a memo', ->
    $httpBackend.flush()
    expect(scope.memo.title).toEqual 'Memo A'

