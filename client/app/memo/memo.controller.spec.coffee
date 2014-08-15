'use strict'

describe 'Controller: MemoCtrl', ->

  # load the controller's module
  beforeEach module 'shiorisApp'
  beforeEach module 'socketMock'
  beforeEach module
    Auth:
      getCurrentUser: () ->
        _id: 'test_user'
  scope = undefined
  MemoCtrl = undefined

  # Initialize the controller and a mock scope

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MemoCtrl = $controller 'MemoCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
