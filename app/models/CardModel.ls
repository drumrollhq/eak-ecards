require! {
  'prelude-ls': {keys}
}

module.exports = class CardModel extends Backbone.Model
  initialize: ->
    @set active-view: \customize, advanced-mode: false
    fields = require "data/templates/#{@get \name}/fields"
    @set fields
    @restore-saved!
    @data-keys = keys fields
    @set \simpleTemplate, require "data/templates/#{@get \name}/simple"
    @template = require "data/templates/#{@get \name}/template"

    @on 'change', _.throttle (~> @save!), 2500ms

  data-to-json: ->
    obj = {}
    for key in @data-keys => obj[key] = @get key
    if @get 'src' then obj.src = that
    obj

  save: ->
    to-save = @data-to-json!
    if to-save !== @_last-saved
      local-storage.set-item "card-save:#{@get 'name'}", JSON.stringify @data-to-json!
      @_last-saved = to-save

  restore-saved: ->
    json = local-storage.get-item "card-save:#{@get 'name'}"
    @set JSON.parse json

  before-publish: (html) ->
    to-add = """
      <script>
        // Remix button:
        var style = document.createElement('link');
        style.setAttribute('href', '//fonts.googleapis.com/css?family=Open+Sans:300');
        style.setAttribute('rel', 'stylesheet');
        document.body.appendChild(style);
        var link = document.createElement('a');
        link.innerHTML = 'Make your own &rarr;';
        link.setAttribute('href', 'https://cards.eraseallkittens.com/');
        link.setAttribute('style', 'display: block; position: absolute; top: 0; right: 0; background-color: rgba(0, 0, 0, 0.5); color: white; text-decoration: none; font-family: "Open Sans", sans-serif; font-size: 18px; font-weight: 300; padding: 5px 10px; border-bottom-left-radius: 10px;');
        document.body.appendChild(link);

        // Analytics
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', '#{window.analyticsId}', 'auto');
        ga('send', 'pageview');
      </script>
    """
    re = /<body\/>/i
    if html.match re
      html = html.replace re, to-add + '</body>'
    else
      html += to-add

    html

  publish: ->
    html = @before-publish if @get 'advancedMode' and @get 'src' then @get 'src' else @template @data-to-json!
    @set 'loading' true
    @unset 'publishError'
    @unset 'file'
    Promise.resolve $.ajax {
      method: \POST
      url: 'https://api.eraseallkittens.com/v1/cards/'
      data-type: \json
      content-type: 'application/json'
      data: JSON.stringify html: html
      cross-domain: true
    }
      .then ({file}) ~>
        local-storage.remove-item "card-save:#{@get \name}"
        @set 'loading' false
        @set 'file' file
      .catch (e) ~>
        @set 'loading' false
        @set 'publishError' true
