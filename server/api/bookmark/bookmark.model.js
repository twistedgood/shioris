'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId,
    timestamps = require('mongoose-timestamp');

var BookmarkSchema = new Schema({
  url: String,
  title: String,
  content: String,
  description: String,
  userId: ObjectId
});

BookmarkSchema.plugin(timestamps);

module.exports = mongoose.model('Bookmark', BookmarkSchema);
