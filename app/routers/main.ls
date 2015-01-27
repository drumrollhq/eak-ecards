class MainRouter extends Backbone.Router
  routes:
    '': 'templateSelect'

  template-select: ->
    TemplateSelectView = require 'views/templateSelect'
    template-select-view = new TemplateSelectView()

main = new MainRouter()
module.exports = main
