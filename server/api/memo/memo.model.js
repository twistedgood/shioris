'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId,
    timestamps = require('mongoose-timestamp');

var MemoSchema = new Schema({
  title: { type: String, required: true},
  content: String,
  userId: ObjectId
});

MemoSchema.plugin(timestamps);

module.exports = mongoose.model('Memo', MemoSchema);
