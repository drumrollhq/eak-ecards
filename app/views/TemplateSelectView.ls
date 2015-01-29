require! {
  'data/cards'
  'models/TemplateSelectModel'
  'views/templates/template-select': template
}

module.exports = class TemplateSelectView extends Backbone.View
  class-name: 'template-select'
  title: -> 'E.A.K. E-Cards'
  initialize: ->
    @model = new TemplateSelectModel!
    @model.setup cards
    @render!

  render: ->
    @model.to-JSON! |> template |> @$el.html
