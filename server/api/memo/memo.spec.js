'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');
var Q = require('q');

var User = require('../user/user.model');
var Memo = require('../memo/memo.model');
var ObjectId = require('mongoose').Types.ObjectId;

var user = new User({
  _id: ObjectId('123456789012'),
  provider: 'local',
  name: 'test user',
  email: 'test@test.com',
  password: 'tset'
});

var memos = [
  new Memo({
    title: 'Test Memo 1',
    content: 'foo bar',
    userId: user._id
  }),
  new Memo({
    title: 'Test Memo 2',
    content: 'woo yeah',
    userId: user._id
  })
];

describe('Memo', function() {

  beforeEach(function(done) {
    Q.all([
      User.remove().exec()
      .then(function() {
        return User.create(user);
      }),
      Memo.remove().exec()
      .then(function() {
        return Memo.create(memos);
      }),
    ])
    .done(function() {
      done();
    });
  });

  describe('GET /api/users/{userId}/memos/{id}', function() {
    it('should respond a memo', function(done) {
      request(app)
        .get('/api/users/' + user._id + '/memos/' + memos[1]._id)
        .expect(200)
        .expect('Content-Type', /json/)
        .end(function(err, res) {
          if (err) return done(err);;
          res.body.title.should.equal('Test Memo 2');
          res.body.content.should.equal('woo yeah');
          res.body.userId.should.equal(user._id.toString());
          done();
        });
    });
    it('should return Not Found if not exists', function(done) {
      request(app)
        .get('/api/users/' + user._id + '/memos/' + '111111111111')
        .expect(404)
        .end(function(err, res) {
          if (err) return done(err);
          done();
        });
    });
  });

  describe('GET /api/users/{userId}/memos', function() {
    it('should respond with JSON array', function(done) {
      request(app)
        .get('/api/users/' + user._id + '/memos')
        .expect(200)
        .expect('Content-Type', /json/)
        .end(function(err, res) {
          if (err) return done(err);
          res.body.should.be.instanceof(Array);
          res.body.should.have.length(2);
          done();
        });
    });
  });

  describe('POST /api/users/{userId}/memos', function() {
    it('should create a memo', function(done) {
      request(app)
        .post('/api/users/' + user._id + '/memos')
        .send({
          title: 'Test Memo A',
          content: 'Content A'
        })
        .expect(201)
        .expect('Content-Type', /json/)
        .end(function(err, res) {
          if (err) return done(err);
          res.body.title.should.equal('Test Memo A');
          res.body.content.should.equal('Content A');
          res.body.userId.should.equal(user._id.toString());
          done();
        });
    });
  });

  describe('PUT /api/users/{userId}/memos', function() {
    it('should update the memo', function(done) {
      request(app)
        .put('/api/users/' + user._id + '/memos/' + memos[0]._id)
        .send({
          title: 'Test Memo 1-1',
          content: 'foo foo'
        })
        .expect(200)
        .expect('Content-Type', /json/)
        .end(function(err, res) {
          if (err) return done(err);
          res.body.title.should.equal('Test Memo 1-1');
          res.body.content.should.equal('foo foo');
          res.body.userId.should.equal(user._id.toString());
          done();
        });
    });
    it('should return Not Found if not exists', function(done) {
      request(app)
        .put('/api/users/' + user._id + '/memos/' + memos[0]._id)
        .send({ title: '' })
        .expect(500)
        .end(function(err, res) {
          if (err) return done(err);
          done();
        });
    });
  });

  describe('DELETE /api/users/{userId}/memos', function() {
    it('should delete the memo', function(done) {
      request(app)
        .delete('/api/users/' + user._id + '/memos/' + memos[0]._id)
        .expect(204)
        .end(function(err, res) {
          if (err) return done(err);
          done();
        });
    });
  });

});

