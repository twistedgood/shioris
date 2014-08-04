'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var User = require('../user/user.model');
var Bookmark = require('../bookmark/bookmark.model');

var user = new User({
  provider: 'local',
  name: 'test user',
  email: 'test@test.com',
  password: 'tset'
});

describe('GET /api/users/{userId}/bookmarks', function() {
  before(function(done) {
    User.remove().exec()
    .then(function() {
      return Bookmark.remove().exec();
    })
    .then(function() {
      return User.create(user);
    })
    .then(function(user) {
      return Bookmark.create({
        url: 'test1',
        content: 'oh yeah',
        userId: user._id
      }, {
        url: 'test1',
        content: 'foo bar',
        userId: user._id
      });
    })
    .then(function() {
      done();
    });
  });

  it('should respond a bookmark list of specified user', function(done) {
    request(app)
      .get('/api/users/' + user._id + '/bookmarks')
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        res.body.should.have.length(2);
        done();
      });
  });

  it('should respond a filtered bookmark list of specified user', function(done) {
    request(app)
      .get('/api/users/' + user._id + '/bookmarks?q=bar')
      .expect(200)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.should.be.instanceof(Array);
        res.body.should.have.length(1);
        done();
      });
  });
});

describe('POST /api/users/{userId}/bookmarks', function() {
  before(function(done) {
    User.remove().exec()
    .then(function() {
      return Bookmark.remove().exec();
    })
    .then(function() {
      return User.create(user);
    })
    .then(function() {
      done();
    });
  });
  
  it('should create a bookmark', function(done) {
    request(app)
      .post('/api/users/' + user._id + '/bookmarks')
      .send({url: 'http://example.com/'})
      .expect(201)
      .expect('Content-Type', /json/)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.url.should.equal('http://example.com/');
        res.body.title.should.equal('Example Domain');
        res.body.userId.should.equal(user._id.toString());
        done();
      });
  });

  it('should happen error when specified URL is invlaid', function(done) {
    request(app)
      .post('/api/users/' + user._id + '/bookmarks')
      .send({url: 'http://example.notfound/'})
      .expect(201)
      .end(function(err, res) {
        if (err) return done(err);
        res.body.url.should.equal('http://example.notfound/');
        res.body.title.should.equal('');
        res.body.userId.should.equal(user._id.toString());
        done();
      });
  });
});

describe('DELETE /api/users/{userId}/bookmarks', function() {
  var bookmark = new Bookmark({
    url: 'test1',
    content: 'oh yeah'
  });
  before(function(done) {
    User.remove().exec()
    .then(function() {
      return Bookmark.remove().exec();
    })
    .then(function() {
      return User.create(user);
    })
    .then(function(user) {
      bookmark.userId = user._id;
      return Bookmark.create(bookmark);
    })
    .then(function() {
      done();
    });
  });

  it('should delete a bookmark', function(done) {
    request(app)
      .delete('/api/users/' + user._id + '/bookmarks/' + bookmark._id)
      .send({url: 'http://example.com/'})
      .expect(204)
      .end(function(err, res) {
        if (err) return done(err);
        done();
      });
  });
});
