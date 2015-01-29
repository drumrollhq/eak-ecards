exports.config = {
  files:
    javascripts:
      joinTo:
        'js/vendor.js': /^(vendor|bower_components)/
        'js/app.js': /^app/

      order:
        after: ['bower_components/swag/lib/swag.js']

      pluginHelpers: 'js/app.js'

    stylesheets:
      joinTo:
        'css/app.css': /^(vendor|bower_components|app)/

    templates:
      joinTo: 'js/app.js'

  plugins:
    autoReload:
      enabled:
        js: on
        css: on
        assets: off

    imageoptimizer:
      path: 'images'
      smushit: no

  conventions:
    assets: /(assets|vendor\/assets|font)/
}
