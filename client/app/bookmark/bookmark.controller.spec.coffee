'use strict'

expect = chai.expect;

describe 'Controller: BookmarkCtrl', ->

  # load the controller's module
  beforeEach module 'shiorisApp'
  beforeEach module 'socketMock'
  beforeEach module
    Auth:
      getCurrentUser: () ->
        _id: 'test_user'

  BookmarkCtrl = undefined
  scope = undefined
  $httpBackend = undefined

  # Initialize the controller and a mock scope
  beforeEach inject (_$httpBackend_, $controller, $rootScope) ->
    $httpBackend = _$httpBackend_
    $httpBackend.whenGET '/api/users/test_user/bookmarks'
    .respond [
      {url: 'http://example.com/'}
      {url: 'http://example.net/'}
    ]
    scope = $rootScope.$new()
    BookmarkCtrl = $controller 'BookmarkCtrl',
      $scope: scope

  it 'should attach a list of bookamrks', ->
    $httpBackend.flush()

    expect(scope.bookmarks.length).to.equal 2

  it 'should attach a queried list of bookamrks', ->
    $httpBackend.expectGET '/api/users/test_user/bookmarks?q=test_query'
    .respond 200
    scope.query = 'test_query'
    scope.searchBookmark()
    $httpBackend.flush()

  it 'should add a bookamrk', ->
    $httpBackend.expectPOST '/api/users/test_user/bookmarks', 
      url: 'http://example.org/',
      userId: 'test_user'
    .respond 201
    scope.bookmark = {url: 'http://example.org/'}
    scope.addBookmark()
    $httpBackend.flush()
    expect(scope.bookmark.url).to.equal ''
  
  it 'should delete the bookmark', ->
    $httpBackend.expectDELETE '/api/users/test_user/bookmarks/test_bookmark'
    .respond 204
    scope.deleteBookmark _id: 'test_bookmark'
    $httpBackend.flush


