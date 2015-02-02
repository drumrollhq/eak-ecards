require! {
  'prelude-ls': {group-by}
}

module.exports = class TemplateSelectModel extends Backbone.DeepModel
  setup: (cards) ->
    for name, card of cards => card.name = name
    @set cards
