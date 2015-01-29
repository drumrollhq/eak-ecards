require! {
  'prelude-ls': {group-by}
}

module.exports = class TemplateSelectModel extends Backbone.DeepModel
  setup: (cards) ->
    @set {[card.name, card] for card in cards}
