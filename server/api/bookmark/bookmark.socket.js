/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Bookmark = require('./bookmark.model');

exports.register = function(socket) {
  Bookmark.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Bookmark.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('bookmark:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('bookmark:remove', doc);
}