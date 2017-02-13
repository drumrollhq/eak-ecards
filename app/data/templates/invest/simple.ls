module.exports =
  * tag: \body
    contents:
      * tag: \h1
        placeholder: \to

      * tag: \img
        attrs: src: '/images/dragons.png'

      * tag: \section
        attrs: class: 'poem'
        contents:
          * tag: \p
            placeholder: 'line1'
          * tag: \p
            placeholder: 'line2'
          * tag: \p
            placeholder: 'line3'
          * tag: \p
            placeholder: 'line4'

      * tag: \p
        placeholder: 'from1'
      * tag: \p
        attrs: class: 'from'
        placeholder: 'from2'
