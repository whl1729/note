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

### Other event concepts

1. Sometimes inside an event handler function, you might see a parameter specified with a name such as `event`, `evt`, or simply `e`. This is called the event object, and it is automatically passed to event handlers to provide extra features and information.

2. `e.target` is incredibly useful when you want to set the same event handler on multiple elements and do something to all of them when an event occurs on them. You might, for example, have a set of 16 tiles that disappear when they are clicked on. It is useful to always be able to just set the thing to disappear as e.target, rather than having to select it in some more difficult way.

3. Sometimes, you'll come across a situation where you want to prevent an event from doing what it does by default. The most common example is that of a web form, for example, a custom registration form.

4. Some browsers support automatic form data validation features, but since many don't, you are advised to not rely on those and implement your own validation checks.

#### Bubbling and capturing explained

1. When an event is fired on an element that has parent elements, modern browsers run two different phases: the **capturing phase** and the **bubbling phase**.

2. In the capturing phase:
    - The browser checks to see if the element's outer-most ancestor (`<html>`) has an onclick event handler registered on it for the capturing phase, and runs it if so.
    - Then it moves on to the next element inside `<html>` and does the same thing, then the next one, and so on until it reaches the element that was actually clicked on.

3. In the bubbling phase, the exact opposite occurs:
    - The browser checks to see if the element that was actually clicked on has an onclick event handler registered on it for the bubbling phase, and runs it if so.
    - Then it moves on to the next immediate ancestor element and does the same thing, then the next one, and so on until it reaches the `<html>` element.

4. In modern browsers, by default, all event handlers are registered for the bubbling phase. If you really want to register an event in the capturing phase instead, you can do so by registering your handler using `addEventListener()`, and setting the optional third property to true.

5. In cases where both types of event handlers are present, bubbling and capturing, the capturing phase will run first, followed by the bubbling phase.

6. The standard Event object has a function available on it called `stopPropagation()` which, when invoked on a handler's event object, makes it so that first handler is run but the event doesn't bubble any further up the chain, so no more handlers will be run.

7. Bubbling also allows us to take advantage of **event delegation** — this concept relies on the fact that if you want some code to run when you click on any one of a large number of child elements, you can set the event listener on their parent and have events that happen on them bubble up to their parent rather than having to set the event listener on every child individually.
