# vim help 学习笔记

## usr_02.txt The first steps in Vim

- `J` join two lines together

- `ZZ` writes the file and exits

- `:help index` get a complete index of all Vim commands

## usr_03.txt Moving around


- `CTRL-U` command scrolls down half a screen of text.
- `CTRL-D` command scrolls up half a screen of text.

- `zz` puts the cursor line at the middle
- `zt` puts the cursor line at the top
- `zb` puts the cursor line at the bottom

- ```` command jumps back and forth, between two points.  
- `CTRL-O` command jumps to older positions (Hint: O for older).  
- `CTRL-I` jumps back to newer positions (Hint: I is just next to O on the keyboard).

## usr_08.txt Splitting windows

- `vimdiff main.c~ main.c` viewing differences between two files

- `:vertical diffsplit main.c~` make a split and show the differences

## usr_12.txt 

- `:%s/\<four\>/4/gc` add the "c" flag to have the substitute command prompt you for each replacement



## index.txt

### insert-index

- `CTRL-G CTRL-J`, `CTRL-G j` line down, to column where inserting started

- `CTRL-G CTRL-K`, `CTRL-G k` line up, to column where inserting started

- `CTRL-R {0-9a-z"%#*:=}` insert the contents of a register

- `CTRL-D` delete one shiftwidth of indent in the current

- `CTRL-T`	 insert one shiftwidth of indent in current

- `CTRL-U`	 delete all entered characters in the current

- `CTRL-W`  delete word before the cursor

- `<S-Left>` cursor one word left
    -
- `<C-Left>` cursor one word left

- `<S-Right>` cursor one word right

- `<C-Right>` cursor one word right

### normal-index

- `["x]C` change from the cursor position to the end of the line, and N-1 more lines [into buffer x]; synonym for "c$"

- `["x]D`	delete the characters under the cursor until the end of the line and N-1 more lines [into buffer x]; synonym for "d$"

- `CTRL-W h` go to Nth left window (stop at first window)
- `CTRL-W j` go N windows down (stop at last window)
- `CTRL-W k` go N windows up (stop at first window)
- `CTRL-W l` go to Nth right window (stop at last window)

- `CTRL-W o` close all but current window (like |:only|)
- `CTRL-W q` quit current window (like |:quit|)
- `CTRL-W n` open new window, N lines high
- `CTRL-W s` split current window in two parts, new window N lines high`CTRL-W t` go to top window
- `CTRL-W v` split current window vertically, new window

