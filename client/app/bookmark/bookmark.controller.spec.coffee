'use strict'

describe 'Controller: BookmarkCtrl', ->

  # load the controller's module
  beforeEach module('shiorisApp')
  beforeEach module('socketMock')
  beforeEach module(Auth: {
    getCurrentUser: () ->
      _id: 'test_user'
  })

  BookmarkCtrl = undefined
  scope = undefined
  $httpBackend = undefined

  # Initialize the controller and a mock scope
  beforeEach inject (_$httpBackend_, $controller, $rootScope) ->
    $httpBackend = _$httpBackend_
    $httpBackend.whenGET('/api/bookmarks?u=test_user').respond [
      {url:'http://example.com/'}
      {url: 'http://example.net/'}
    ]
    scope = $rootScope.$new()
    BookmarkCtrl = $controller 'BookmarkCtrl',
      $scope: scope

  it 'should attach a list of bookamrks', ->
    $httpBackend.flush()
    expect(scope.bookmarks.length).toEqual 2

  it 'should add a bookamrk', ->
    $httpBackend.expectPOST('/api/bookmarks', {
      url: 'http://example.org/',
      userId: 'test_user'
    }).respond 201
    scope.bookmark = {url: 'http://example.org/'}
    scope.addBookmark()
    $httpBackend.flush()
    expect(scope.bookmarks.length).toEqual 2
    expect(scope.bookmark.url).toEqual ''
  
  it 'should delete the bookmark', ->
    $httpBackend.expectDELETE('/api/bookmarks/test_bookmark').respond 204
    scope.deleteBookmark _id: 'test_bookmark'
    $httpBackend.flush


