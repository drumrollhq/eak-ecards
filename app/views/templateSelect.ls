template = require 'views/templates/templateSelect'

module.exports = class TemplateSelectView extends Backbone.View
  class-name: 'templateSelect'
  initialize: ->
    @render!

  render: ->
    @$el.html template!
    console.log 'render'
