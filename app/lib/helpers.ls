require! {
  'prelude-ls': {initial, filter, is-type, map, join}
}

# Tell Swag where to look for partials
Swag.Config.partials-path = '../views/templates/'
Swag.register-helpers!

# Put your handlebars.js helpers here.
Handlebars.register-helper 'urlencode' (...args) ->
  args
  |> initial
  |> filter is-type 'String'
  |> map encode-URI-component
  |> join ''
