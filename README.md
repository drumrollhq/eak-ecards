# eak-ecards

eak-ecards is the little hackable ecard app at http://cards.eraseallkittens.com.

Unfortunately it's old and doesn't build on recent versions of node, so you need node v0.10 (lolsob)
to build it.

After closing and using node v0.10 (try nvm, maybe?) you can get started with:

- `npm install`
- `bower install`
- `npm start`

That should start up a little server on localhost:3333 running the application.
To customise the cards, change the files in `app/data`.

- `cards.ls` lists the available cards - each one needs an id, image, and alt text.
- `templates/$cardName/fields.ls` has default values for any editable bit of the card
- `templates/$cardName/simple.ls` defines the card template that gets shown in the 'simple' editor
- `templates/$cardName/template.hbs` is the full handlebars template for the card

The `simple.ls` defines a sort of HTML structure. There's two types of item in here:

##### tags:

these define html elements and have a tag name, attributes, and contents
```
* tag: 'some-tag-name'
  attrs:
    some-attr: 'attr-value'
    other-attr: 'other-attr-value'
  content:
    * other item (tag or placeholder)
    * other item (tag or placeholder)
```

##### placeholder:

these define textboxes where users can write in their own content:
```
* placeholder: 'placeholder-name'
```

