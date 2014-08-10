'use strict';

var _ = require('lodash');
var Memo = require('./memo.model');

// Get list of memos
exports.index = function(req, res) {
  Memo.find(function (err, memos) {
    if(err) { return handleError(res, err); }
    return res.status(200).json(memos);
  });
};

// Get a single memo
exports.show = function(req, res) {
  Memo.findById(req.params.id, function (err, memo) {
    if(err) { return handleError(res, err); }
    if(!memo) { return res.send(404); }
    return res.json(memo);
  });
};

// Creates a new memo in the DB.
exports.create = function(req, res) {
  var memo = new Memo(req.body);
  memo.userId = req.params.userId;
  Memo.create(memo, function(err, memo) {
    if(err) { return handleError(res, err); }
    return res.status(201).json(memo);
  });
};

// Uedates an existing memo in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Memo.findById(req.params.id, function (err, memo) {
    if (err) { return handleError(res, err); }
    if(!memo) { return res.send(404); }
    var updated = _.merge(memo, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.status(200).json(updated);
    });
  });
};

// Deletes a memo from the DB.
exports.destroy = function(req, res) {
  Memo.findById(req.params.id, function (err, memo) {
    if(err) { return handleError(res, err); }
    if(!memo) { return res.send(404); }
    memo.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.status(204).end();
    });
  });
};

function handleError(res, err) {
  if (err.message && err.message.match(/Cast to ObjectId failed/)) {
    return res.status(404).end();
  }
  return res.status(500).end();
}
