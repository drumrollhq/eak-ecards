class MainRouter extends Backbone.Router
  routes:
    '': 'templateSelect'
    'remix/:name': 'customize'
    'remix/:name/preview': 'customizePreview'
    'remix/:name/publish': 'customizePublish'

  initialize: ({$root}) ->
    @$root = $root
    @_last-trans = Promise.resolve {}

  show: (view-name, ...args) ->
    @_last-trans = @_last-trans
      .then ~> if @_last-view then @_last-view.remove!
      .then ~>
        View = require view-name
        view = @_last-view = new View ...args
        document.title = view.title!
        @$root
          ..empty!
          ..append view.$el

        {view, view-name, args}

  template-select: -> @show 'views/TemplateSelectView'
  customize: (name, prevent-change-show = false) ->
    @_last-trans.then ({view, view-name, args = []}) ~>
      if view-name is 'views/CustomizeView' and args.0 === {name}
        view.show-customize!
        view
      else
        @show 'views/CustomizeView', {name}
          .then ({view}) -> view

  customize-preview: (name) ->
    @customize name, true .then (view) -> view.show-preview!

  customize-publish: (name) ->
    @customize name, true .then (view) -> view.show-publish!

main = new MainRouter $root: $ 'body > .app'
module.exports = main
