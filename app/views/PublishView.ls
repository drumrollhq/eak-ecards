require! {
  'views/templates/publish': template
}

module.exports = class PublishView extends Backbone.View
  class-name: 'publish-view'
  events:
    'click .publish-share-anonymous button': 'shareAnonymous'

  initialize: ->
    @render!
    @listen-to @model, 'change:loading change:file change:publishError change:sharing change:sharingError change:sharingSuccess', @render

  render: ->
    @model.to-JSON! |> template |> @$el.html

  share-anonymous: ->
    file = @model.get \file
    user = @$ '[name=twitter-handle]' .val! .trim!

    @model.unset 'sharingError'
    @model.unset 'sharingSuccess'
    @model.set 'sharing' true

    Promise.resolve $.ajax {
      method: \POST
      url: 'https://api.eraseallkittens.com/v1/cards/share'
      data-type: \json
      content-type: 'application/json'
      data: JSON.stringify user: user, card: file
      cross-domain: true
    }
      .then ~> @model.set 'sharingSuccess' true
      .catch (e) ~>
        @model.set 'sharingError' (e.response-JSON?.details or e.status-text)
      .finally ~>
        @model.unset 'sharing'
