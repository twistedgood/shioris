'use strict';

var config = require('../../config/environment');
var _ = require('lodash');
var Bookmark = require('./bookmark.model');
var auth = require('../../auth/auth.service');
var Q = require('q');
var request = require('request');
var cheerio = require('cheerio');
var jschardet = require('jschardet');
var Iconv = require('iconv').Iconv;

// Get list of bookmarks
exports.index = function(req, res) {
  var query = Bookmark.find();
  if (req.params.userId) {
    query.where({userId: req.params.userId});
  }
  if (req.param('q')) {
    _.each(req.param('q').split(/\s+/), function(q) {
        query.where({content: new RegExp(q, 'i')});
    });
  }
  query.sort('createdAt');
  query.exec(function (err, bookmarks) {
    if(err) { return handleError(res, err); }
    return res.status(200).json(bookmarks);
  });
};

// Get a single bookmark
exports.show = function(req, res) {
  Bookmark.findById(req.params.id, function (err, bookmark) {
    if(err) { return handleError(res, err); }
    if(!bookmark) { return res.status(404).end(); }
    return res.json(bookmark);
  });
};

// Creates a new bookmark in the DB.
exports.create = function(req, res) {
  var convert = function(text) {
    var detected = jschardet.detect(text);
    var iconv = new Iconv(detected.encoding, 'UTF-8//TRANSLIT//IGNORE');
    return iconv.convert(text).toString();
  };
  Q.nfcall(request.get, {
    url: req.param('url'),
    encoding: 'binary',
    timeout: config.linkCheckerTimeout || 3000 
  })
  .spread(function(response, body) {
    var $ = cheerio.load(convert(new Buffer(body, 'binary')));
    return Bookmark.create({
      url: req.param('url'),
      title: $('title').text(),
      content: $.root().text().replace(/<|>/g, ''),
      description: $('meta[name=description]').attr('content'),
      userId: req.params.userId
    });
  })
  .then(function(bookmark) {
    return res.status(201).json(bookmark);
  })
  .catch(function(err) {
    Q(Bookmark.create({
      url: req.param('url'),
      title: '',
      content: '',
      description: '',
      userId: req.params.userId
    }))
    .then(function(bookmark) {
      return res.status(201).json(bookmark);
    })
    .catch(function(err) {
      return handleError(res, err);
    })
    .done();
  })
  .done();
};

// Updates an existing bookmark in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Bookmark.findById(req.params.id, function (err, bookmark) {
    if (err) { return handleError(res, err); }
    if(!bookmark) { return res.send(404); }
    var updated = _.merge(bookmark, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.status(200).json(bookmark);
    });
  });
};

// Deletes a bookmark from the DB.
exports.destroy = function(req, res) {
  Bookmark.findById(req.params.id, function (err, bookmark) {
    if(err) { return handleError(res, err); }
    if(!bookmark) { return res.send(404); }
    bookmark.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.status(204).end();
    });
  });
};

function handleError(res, err) {
  return res.status(500).send(err);
}
