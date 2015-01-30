require! {
  'views/templates/publish': template
}

module.exports = class PublishView extends Backbone.View
  class-name: 'publish-view'
  initialize: ->
    @render!
    @listen-to @model, 'change:loading change:file change:publishError', @render

  render: ->
    @model.to-JSON! |> template |> @$el.html
