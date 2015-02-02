require! {
  'prelude-ls': {dasherize}
}

module.exports = class TemplateSelectModel extends Backbone.DeepModel
  setup: (cards) ->
    for name, card of cards => card.name = dasherize name
    @set cards
