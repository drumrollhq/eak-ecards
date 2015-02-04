require! {
  'prelude-ls': {dasherize}
  'views/templates/simple-customizer': template
}

render-html = (structure, data) ->
  | typeof! structure is 'Array' => structure.map ( (item) -> render-html item, data ) .join '\n'
  | typeof! structure is 'Object' => render-one structure, data
  | otherwise => structure.to-string!

render-one = (structure, data) ->
  | typeof structure.tag is \string => render-tag structure, data
  | typeof structure.placeholder is \string => render-placeholder structure, data
  | otherwise => throw new Error "Cannot render structure: #{JSON.stringify structure, null, 2}"

# Horrible whitespace to prevent gaps from showing up everywhere:
render-tag = (structure, data) ->
  """
    <div class="tag tag-#{structure.tag.to-lower-case!} #{if structure.contents then 'tag-has-contents' else ''} contains-tags-#{contains-tags structure} #{if contains-tags structure then 'tag-contains-tags' else ''}" data-tag-name="#{structure.tag}">
      <div class="tag-open">
        <span class="tag-angle-bracket">&lt;</span><span class="tag-tagname">#{structure.tag}</span>#{if structure.attrs? then """
          <span class="tag-attributes">
            #{(for name, value of structure.attrs => render-attr name, value, data).join ' '}
           </span>
        """ else ''}<span class="tag-angle-bracket">&gt;</span>
      </div>
      <div class="tag-contents">
        #{if structure.contents
            render-html structure.contents, data
          else if structure.placeholder
            render-placeholder structure, data
        }
      </div>
      <div class="tag-close">
        <span class="tag-angle-bracket">&lt;/</span><span class="tag-tagname">#{structure.tag}</span><span class="tag-angle-bracket">&gt;</span>
      </div>
    </div>
  """

render-placeholder = ({placeholder}, data) -> """
  <textarea class="tag-placeholder textarea-autoextend" data-placeholder="#{placeholder}">#{data[placeholder]}</textarea>"""

render-attr = (name, value, data) -> """
  <span class="tag-attribute-name">#{dasherize name}</span><span class="tag-attribute-equals">=</span><span class="tag-attribute-quote">&quot;</span><span class="tag-attribute-value">#{render-attr-value value, data}</span><span class="tag-attribute-quote">&quot;</span>
"""

render-attr-value = (value, data) ->
  | typeof! value is 'String' => value
  | value.placeholder? => """<input type="text" class="tag-attr-placeholder" data-placeholder="#{value.placeholder}" value="#{data[value.placeholder]}">"""

contains-tags = (structure) ->
  structure.contents? and
    (typeof! structure.contents is 'Array' and structure.contents.filter ( .tag? ) .length) or
    (typeof! structure.contents is 'Object' and structure.contents.tag?)

get-tag-open-close = ($tag) ->
  $open = if $tag.data 'tag-open'
    that
  else
    o = $tag.find '.tag-open'
    $tag.data 'tag-open' o
    o

  $close = if $tag.data 'tag-close'
    that
  else
    o = $tag.find '.tag-close'
    $tag.data 'tag-close', o
    o

  {$open, $close}

$util-el = $ '<div id="simple-customizer-view-util"></div>'
  .add-class 'textarea'
  .css {
    visibility: \hidden
    pointer-events: \none
    position: \absolute
    top: 0
    left: 0
    white-space: \pre-wrap
    word-wrap: \break-word
    background: \white
    z-index: 100
  }
  .append-to document.body

module.exports = class SimpleCustomizerView extends Backbone.View
  class-name: 'simple-customizer'

  events:
    'change textarea': 'textareaChange'
    'keyup textarea': 'textareaChange'
    'keypress textarea': 'textareaChange'
    'change input': 'inputChange'
    'keyup input': 'inputChange'
    'keypress input': 'inputChange'

  initialize: ->
    @render!

  render: ->
    template-structure = @model.get 'simpleTemplate'
    data = @model.to-JSON!
    html = render-html template-structure, data
    @$el.html html
    @resize-all!
    set-timeout @resize-all, 500

  update: ->
    @resize-all!

  resize-all: ~>
    @$el.find 'textarea' .each (i, el) ~>
      $el = $ el
      @textarea-resize $el, $el.val!

    @$el.find 'input' .each (i, el) ~>
      $el = $ el
      @input-resize $el, $el.val!

  textarea-change: (e) ->
    $el = $ e.target
    val = $el.val!
    unless val is $el.data \last-val
      @textarea-resize $el, val
      @model.set ($el.data 'placeholder'), val
      $el.data \last-val, val

  input-change: (e) ->
    $el = $ e.target
    val = $el.val!
    unless val is $el.data \last-val
      @input-resize $el, val
      @model.set ($el.data 'placeholder'), val
      $el.data \last-val, val

  input-resize: ($el, val) ->
    $util-el.text val + ' '
    {width} = @calc-textarea-dimension 200
    $el.css {width}

  textarea-resize: ($el, val) ->
    $util-el.text val + ' '
    $tag-contents = $el.parent!
    $tag = $tag-contents.parent!
    {$open, $close} = get-tag-open-close $tag

    max-inline-width = $tag.inner-width! - $open.width! - $close.width! - 60
    {width, height} = @calc-textarea-dimension max-inline-width

    if height > 30 or $tag.has-class 'tag-contains-tags'
      # Block mode:
      $tag-contents.css display: 'block'
      $util-el.css max-width: $tag-contents.width!
      {width, height} = @calc-textarea-dimension $tag-contents.width! - 10
    else
      # Inline mode:
      $tag-contents.css display: 'inline-block'

    $el.css {
      width: width
      height: height
    }

  calc-textarea-dimension: (max-width) ->
    $util-el.css {max-width}
    {
      width: $util-el.outer-width! + 10
      height: $util-el.outer-height!
    }
