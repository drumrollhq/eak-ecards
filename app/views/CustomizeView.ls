require! {
  'models/CardModel'
  'views/AdvancedCustomizerView'
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
    'click .customize-type-toggle': 'toggleAdvancedMode'

  initialize: ({name}) ->
    @model = new CardModel name: name
    @preview = new PreviewView model: @model
    @publish = new PublishView model: @model
    @listen-to @model, 'change:activeView', @change-active-view
    @listen-to @model, 'change:advancedMode', @change-advanced-mode
    @render!

  render: ->
    @model.to-JSON! |> template |> @$el.html
    @$customize-pane = @$ '.customizer-inject'

    @$preview-pane = @$ '.preview-pane'
    @$publish-pane = @$ '.publish-pane'
    @$advanced-mode-toggle = @$ '.customize-type-toggle'

    @preview.$el.append-to @$preview-pane
    @preview.update!

    @publish.$el.append-to @$publish-pane

    @change-active-view!
    @change-advanced-mode!

  dismiss-instructions: ->
    @$ '.customize-instructions' .remove!

  change-active-view: ->
    @$el
      ..remove-class 'show-customize show-preview show-publish'
      ..add-class "show-#{@model.get 'activeView'}"

  change-advanced-mode: ->
    @$advanced-mode-toggle.text if @model.get 'advancedMode' then 'Simple' else 'Advanced'
    customizer = @get-customizer!
    @$customize-pane
      ..empty!
      ..append customizer.el

    customizer.update!

  get-customizer: ->
    if @model.get 'advancedMode'
      @get-advanced-customizer!
    else
      @get-simple-customizer!

  get-simple-customizer: ->
    if @_simple-customizer then return that
    @_simple-customizer = new SimpleCustomizerView model: @model

  get-advanced-customizer: ->
    if @_advanced-customizer then return that
    @_advanced-customizer = new AdvancedCustomizerView model: @model

  toggle-advanced-mode: ->
    @model.set 'advancedMode', not @model.get 'advancedMode'

  show-preview: -> @model.set 'activeView' \preview
  show-customize: -> @model.set 'activeView' \customize
  show-publish: ->
    @model.set 'activeView' \publish
    @model.publish!
  show-advanced: -> @model.set 'advancedMode' true
  show-simple: -> @model.set 'advancedMode' false
