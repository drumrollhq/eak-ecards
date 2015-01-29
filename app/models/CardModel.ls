require! {
  'prelude-ls': {keys}
}

module.exports = class CardModel extends Backbone.Model
  initialize: ->
    @set show-preview: false, advanced-mode: false
    fields = require "data/templates/#{@get \name}/fields"
    @set fields
    @data-keys = keys fields
    @set \simpleTemplate, require "data/templates/#{@get \name}/simple"

  data-to-json: ->
    obj = {}
    for key in @data-keys => obj[key] = @get key
    obj

