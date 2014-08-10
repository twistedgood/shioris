'use strict';

var express = require('express');
var controller = require('./user.controller');
var bookmarkController = require('../bookmark/bookmark.controller');
var memoController = require('../memo/memo.controller');
var config = require('../../config/environment');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', auth.hasRole('admin'), controller.index);
router.delete('/:id', auth.hasRole('admin'), controller.destroy);
router.get('/me', auth.isAuthenticated(), controller.me);
router.put('/:id/password', auth.isAuthenticated(), controller.changePassword);
router.get('/:id', auth.isAuthenticated(), controller.show);
router.post('/', controller.create);

router.route('/:userId/bookmarks')
.get(bookmarkController.index)
.post(bookmarkController.create);

router.route('/:userId/bookmarks/:id')
.delete(bookmarkController.destroy);

router.route('/:userId/memos')
.get(memoController.index)
.post(memoController.create);

router.route('/:userId/memos/:id')
.get(memoController.show)
.put(memoController.update)
.delete(memoController.destroy);


module.exports = router;
