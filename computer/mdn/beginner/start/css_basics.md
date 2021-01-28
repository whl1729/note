# Reading Note: CSS Basics

1. CSS (Cascading Style Sheets) is the code that **styles** web content. **CSS is a style sheet language.** CSS is what you use to selectively style HTML elements.

2. Anatomy of a CSS **ruleset**
  - selector
  - Declaration
  - Properties
  - Property value

3. Some important parts of the ruleset syntax
  - Apart from the selector, each ruleset must be wrapped in curly braces. (`{}`)
  - Within each declaration, you must use a colon (`:`) to separate the property from its value or values.
  - Within each ruleset, you must use a semicolon (`;`) to separate each declaration from the next one.
  - To select multiple elements and apply a single ruleset to all of them, you should separate multiple selectors by commas. (`,`)

4. Different types of selectors
  - Element selector (sometimes called a tag or type selector).
  - ID selector. On a given HTML page, each id value should be unique.
  - Class selector.
  - Attribute selector.
  - Pseudo-class selector. The specified element(s), but only when in the specified state.

5. Choose a font
  - Add the `<link>` element somewhere inside your html's **head**. For example: `<link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">`.
  - Add the `font-family` properties in your css document. For example: `html { font-family: "Open Sans", sans-serif; }`

6. CSS layout is mostly based on the **box model**. Each box has properties like:
  - padding, the space around the content.
  - border, the solid line that is just outside the padding.
  - margin, the space around the outside of the border.

7. Other properties
  - `padding: 0 20px 20px 20px;` The values set top, right, bottom, left, in that order.
  - `border: 5px solid black;` This sets values for the width, style and color of the border.
  - `margin: 0 auto` Here, `auto` is a special value that divides the available horizontal space evenly between left and right.
  - `text-shadow: 3px 3px 1px black;`
    - The first pixel value sets the **horizontal offset** of the shadow from the text: how far it moves across.
    - The second pixel value sets the **vertical offset** of the shadow from the text: how far it moves down.
    - The third pixel value sets the **blur radius** of the shadow. A larger value produces a more fuzzy-looking shadow.
    - The fourth value sets the base color of the shadow.

8. `display: block;`
  - The `<body>` is a **block** element, meaning it takes up space on the page. A block element can have margin and other spacing values applied to it.
  - images are **inline** elements. It is not possible to apply margin or spacing values to inline elements.
  - To apply margins to the image, we must give the image block-level behavior using `display: block;`
