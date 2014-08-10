/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Memo = require('./memo.model');

exports.register = function(socket) {
  Memo.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Memo.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('memo:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('memo:remove', doc);
}