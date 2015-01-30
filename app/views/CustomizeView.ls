require! {
  'models/CardModel'
  'views/PreviewView'
  'views/PublishView'
  'views/SimpleCustomizerView'
  'views/templates/customize': template
}

module.exports = class CustomizeView extends Backbone.View
  class-name: 'customize-container'
  title: ->
    "Remix '#{@model.get 'title'}' | E.A.K. E-Cards"

  events:
    'click .customize-instructions-dismiss': 'dismissInstructions'

  initialize: ({name}) ->
    @model = new CardModel name: name
    @preview = new PreviewView model: @model
    @publish = new PublishView model: @model
    @listen-to @model, 'change:activeView', @change-active-view
    @render!

  render: ->
    @model.to-JSON! |> template |> @$el.html
    @$customize-pane = @$ '.customizer-inject'

    @$preview-pane = @$ '.preview-pane'
    @$publish-pane = @$ '.publish-pane'

    @preview.$el.append-to @$preview-pane
    @preview.update!

    @publish.$el.append-to @$publish-pane

    @change-active-view!
    @change-advanced-mode!

  dismiss-instructions: ->
    @$ '.customize-instructions' .remove!

  change-active-view: ->
    console.log 'change-active-view' @model.get 'activeView'
    @$el
      ..remove-class 'show-customize show-preview show-publish'
      ..add-class "show-#{@model.get 'activeView'}"

  change-advanced-mode: ->
    @$customize-pane
      ..empty!
      ..append @get-customizer!.el

  get-customizer: ->
    @get-simple-customizer!

  get-simple-customizer: ->
    if @_simple-customizer then return that
    @_simple-customizer = new SimpleCustomizerView model: @model

  show-preview: -> @model.set 'activeView' \preview
  show-customize: -> @model.set 'activeView' \customize
  show-publish: ->
    @model.set 'activeView' \publish
    @model.publish!
  show-advanced: -> @model.set 'advancedMode' true
  show-simple: -> @model.set 'advancedMode' false
