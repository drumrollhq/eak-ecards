module.exports = class AdvancedCustomizerView extends Backbone.View
  initialize: ->
    @render!

  render: ->
    @cm = CodeMirror @el, {
      value: @get-src!
      mode: \htmlmixed
      theme: 'solarized light'
      tabsize: 2
      line-numbers: true
      line-wrapping: true
      viewport-margin: Infinity
    }

    @cm.on 'change' ~> @model.set 'src', @cm.get-value!

  update: ->
    @cm.refresh!
    @cm.set-value @get-src!

  get-src: ->
    if @model.get 'src'
      return that
    else
      @model.template @model.data-to-json!
