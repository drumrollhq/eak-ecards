module.exports = class PreviewView extends Backbone.View
  class-name: 'preview-view'
  initialize: ->
    @update = _.throttle (@_update.bind this), 500
    @template = require "data/templates/#{@model.get \name}/template"
    @setup!
    @listen-to @model, 'change', @update

  render: (fields) ->
    html = @template fields
    @try-render html

  try-render: (html) ->
    doc = @iframe.content-document or @iframe.content-window?.document
    if doc
      doc
        ..open!
        ..write html
        ..close!
    else
      set-timeout (~> @try-render html), 1

  _update: ->
    fields = @model.data-to-json!
    unless @_last-fields === fields
      @_last-fields = fields
      @render fields

  setup: ->
    @$iframe = $ '<iframe></iframe>'
      ..add-class 'preview-frame'
      ..append-to @$el

    @iframe = @$iframe.get 0
