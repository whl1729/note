# MDN Note: Getting started with HTML

1. Block versus inline elements
  - Block-level elements form a visible block on a page. A block-level element appears on a new line following the content that precedes it. Any content that follows a block-level element also appears on a new line.
  - Inline elements are contained within block-level elements, and surround only small parts of the document’s content (not entire paragraphs or groupings of content). An inline element will not cause a new line to appear in the document.
  - A block-level element wouldn't be nested inside an inline element, but it might be nested inside another block-level element.

2. Empty elements: Not all elements follow the pattern of an opening tag, content, and a closing tag. Some elements consist of a single tag, which is typically used to insert/embed something in the document.

3. Some attributes of anchor
  - href: specifies the web address for the link.
  - title: specifies extra information about the link, such as a description of the page that is being linked to. This appears as a tooltip when a cursor hovers over the element.
  - target: specifies the browsing context used to display the link.

4. Boolean attributes
  - The presence of a boolean attribute on an element represents the true value, and the absence of the attribute represents the false value.
  - If the attribute is present, its value must either be the empty string or a value that is an ASCII case-insensitive match for the attribute's canonical name, with no leading or trailing whitespace.

5. **Always include the attribute quotes.** It avoids unexpected problems, and results in more readable code.

6. You can wrap attributes in eithor double quotes or single quotes. But make sure you **don't mix single quotes and double quotes.**

7. No matter how much whitespace you use inside HTML element content (which can include one or more space character, but also line breaks), the HTML parser reduces each sequence of whitespace to a single space when rendering the code.

8. In HTML, the characters `<`, `>`, `'` and `&` are **special characters**. So how do you include one of these special characters in your test? You do this with **character references**.

| Literal character | Character reference equivalent |
| -- | -- |
| < | `&lt;` |
| > | `&gt;` |
| " | `&quot;` |
| ' | `&apos;` |
| & | `&amp;` |

9. To write an HTML comment, wrap it in the special markers `<!--` and `-->`.
