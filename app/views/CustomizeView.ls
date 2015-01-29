require! {
  'models/CardModel'
  'views/PreviewView'
  'views/SimpleCustomizerView'
  'views/templates/customize': template
}

module.exports = class CustomizeView extends Backbone.View
  class-name: 'customize-container'
  title: ->
    "Remix #{@model.get 'title'} | E.A.K. E-Cards"

  events:
    'click .customize-instructions-dismiss': 'dismissInstructions'

  initialize: ({name}) ->
    @model = new CardModel name: name
    @preview = new PreviewView model: @model
    @listen-to @model, 'change:showPreview', @change-show-preview
    @render!

  render: ->
    @model.to-JSON! |> template |> @$el.html
    @$customize-pane = @$ '.customizer-inject'
    @$preview-pane = @$ '.preview-pane'
    @preview.$el.append-to @$preview-pane
    @preview.update!
    @change-advanced-mode!

  dismiss-instructions: ->
    @$ '.customize-instructions' .remove!

  change-show-preview: ->
    if @model.get 'showPreview'
      @$el.add-class 'show-preview'
    else
      @$el.remove-class 'show-preview'

  change-advanced-mode: ->
    @$customize-pane
      ..empty!
      ..append @get-customizer!.el

  get-customizer: ->
    @get-simple-customizer!

  get-simple-customizer: ->
    if @_simple-customizer then return that
    @_simple-customizer = new SimpleCustomizerView model: @model

  show-preview: -> @model.set 'showPreview' true
  show-customize: -> @model.set 'showPreview' false
  show-advanced: -> @model.set 'advancedMode' true
  show-simple: -> @model.set 'advancedMode' false
