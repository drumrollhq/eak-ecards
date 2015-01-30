require! {
  'prelude-ls': {keys}
}

module.exports = class CardModel extends Backbone.Model
  initialize: ->
    @set active-view: \customize, advanced-mode: false
    fields = require "data/templates/#{@get \name}/fields"
    @set fields
    @restore-saved!
    @data-keys = keys fields
    @set \simpleTemplate, require "data/templates/#{@get \name}/simple"

    @on 'change', _.throttle (~> @save!), 2500ms

  data-to-json: ->
    obj = {}
    for key in @data-keys => obj[key] = @get key
    obj

  save: ->
    local-storage.set-item "card-save:#{@get 'name'}", JSON.stringify @data-to-json!

  restore-saved: ->
    json = local-storage.get-item "card-save:#{@get 'name'}"
    @set JSON.parse json

  publish: ->
    template = require "data/templates/#{@get \name}/template"
    html = template @data-to-json!
    @set 'loading' true
    @unset 'publishError'
    @unset 'file'
    Promise.resolve $.ajax {
      method: \POST
      url: 'https://api.eraseallkittens.com/v1/cards/'
      data-type: \json
      content-type: 'application/json'
      data: JSON.stringify html: html
      cross-domain: true
    }
      .then ({file}) ~>
        @set 'loading' false
        @set 'file' file
      .catch (e) ~>
        @set 'loading' false
        @set 'publishError' true
