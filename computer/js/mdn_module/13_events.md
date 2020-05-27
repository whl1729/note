# JavaScript MDN

## 13 Introduction to events

### A series of fortunate events

1. Events are actions or occurrences that happen in the system you are programming, which the system tells you about so you can respond to them in some way if desired.

2. Each available event has an **event handler**, which is a block of code (usually a JavaScript function that you as a programmer create) that will be run when the event fires. When such a block of code is defined to be run in response to an event firing, we say we are **registering an event handler**.

3. Event handlers are sometimes called **event listeners** — they are pretty much interchangeable for our purposes, although strictly speaking, they work together. The listener listens out for the event happening, and the handler is the code that is run in response to it happening.

4. **Web events** are not part of the core JavaScript language — they are defined as part of the APIs built into the browser.

5. Events are not unique to JavaScript — most programming languages have some kind of event model, and the way the model works often differs from JavaScript's way. In fact, the event model in JavaScript for web pages differs from the event model for JavaScript as it is used in other environments.

### Ways of using web events

1. Event handler properties
    - `btn.onclick`
    - `btn.onfocus` and `btn.onblur`: The event handler is run when the button is focused and unfocused; try pressing tab to focus on the button and press tab again to focus away from the button. These are often used to display information about how to fill in form fields when they are focused, or display an error message if a form field has just been filled in with an incorrect value.
    - `btn.ondblclick`: The event handler is run only when the button is double-clicked.
    - `window.onkeypress, window.onkeydown, window.onkeyup`: The event handler is run when a key is pressed on the keyboard. The keypress event refers to a general press (button down and then up), while keydown and keyup refer to just the key down and key up parts of the keystroke, respectively.
    - `btn.onmouseover` and `btn.onmouseout`: The event handler is run when the mouse pointer is moved so it begins hovering over the button, or when pointer stops hovering over the button and moves off of it, respectively.

2. With JavaScript, you could easily add an event handler function to all the buttons on the page no matter how many there were, using something like this:
```
const buttons = document.querySelectorAll('button');

for (let i = 0; i < buttons.length; i++) {
  buttons[i].onclick = bgChange;
}
```

3. Note that another option here would be to use the `forEach()` built-in method available on NodeList objects:
```
buttons.forEach(function(button) {
  button.onclick = bgChange;
});
```

4. Separating your programming logic from your content also makes your site more friendly to search engines.

5. It is perfectly appropriate to put all the code inside the addEventListener() function, in an anonymous function.

6. The `addEventListener/removeEventListener` mechanism has some advantages over the older mechanisms discussed earlier.
    - It can improve efficiency to clean up old unused event handlers.
    - This allows you to have the same button performing different actions in different circumstances — all you have to do is add or remove event handlers as appropriate.
    - You can also register multiple handlers for the same listener.
    - In addition, there are a number of other powerful features and options available with this event mechanism. If you want to read up on them, have a look at the addEventListener() and removeEventListener() reference pages.

7. The following two handlers wouldn't both be applied. The second line **overwrites** the value of onclick set by the first line.
```
myElement.onclick = functionA;
myElement.onclick = functionB;
```

8. `Event handler properties` vs `DOM Level 2 Events`
    - Event handler properties have less power and options, but better cross-browser compatibility (being supported as far back as Internet Explorer 8). You should probably start with these as you are learning.
    - DOM Level 2 Events (addEventListener(), etc.) are more powerful, but can also become more complex and are less well supported (supported as far back as Internet Explorer 9). You should also experiment with these, and aim to use them where possible.
