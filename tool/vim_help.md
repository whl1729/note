# vim help 学习笔记

## usr_02.txt The first steps in Vim

- `J` join two lines together

- `ZZ` writes the file and exits

- `:help index` get a complete index of all Vim commands

- `:tab h` open help document in a full window

## usr_03.txt Moving around

- `CTRL-U` command scrolls down half a screen of text.
- `CTRL-D` command scrolls up half a screen of text.

- `zz` puts the cursor line at the middle
- `zt` puts the cursor line at the top
- `zb` puts the cursor line at the bottom

- ```` command jumps back and forth, between two points.  
- `CTRL-O` command jumps to older positions (Hint: O for older).  
- `CTRL-I` jumps back to newer positions (Hint: I is just next to O on the keyboard).

- `:marks` get a list of marks

## usr_07.txt Editing more than one file

- `:edit foo.txt` edit another file

- `:help E37` Vim puts an error ID at the start of each error message.  If you do not understand the message or what caused it, look in the help system for this ID.

- `:args` list the file in the argument list

- `:saveas move.c` save current file under a new name "move.c", and edit that file.

- `:file move.c` save current file under a new name "move,c", but don't edit that file.

- `:only` closes all windows, except for the current one.

## usr_08.txt Splitting windows

- `vimdiff main.c~ main.c` viewing differences between two files

- `:vertical diffsplit main.c~` make a split and show the differences

- `:tab split` makes a new tab page with one window that is editing the same buffer as the window we were in.

- `:tab help gt` You can put ":tab" before any Ex command that opens a window.  The window will be opened in a new tab page.

## usr_12.txt Clever tricks

- `:%s/\<four\>/4/gc` add the "c" flag to have the substitute command prompt you for each replacement

## usr_20.txt Typing command-line commands quickly

- `<S-Left> or <C-Left>`	one word left
- `<<S-Right> or <C-Right>`	one word right
- `<CTRL-B> or <Home>`	    to begin of command line
- `<CTRL-E> or <End>`		to end of command line

- `q:` Vim now opens a (small) window at the bottom.  It contains the command line history, and an empty line at the end.

- `:!{program}`		    execute {program}
- `:r !{program}`		execute {program} and read its output
- `:w !{program}`		execute {program} and send text to its input
- `:[range]!{program}`	filter text through {program}

## usr22.txt Finding the file to edit

- `gf` Move the cursor on the name of the file and type `gf`, Vim will find the file and edit it.

- `:set path+=c:/prog/include` Vim will use the 'path' option to find the file. This command will add it to the 'path' option.

- `:find inits.h` Vim will then use the 'path' option to try and locate the file.

- `vim "+find stdio.h"` directly start Vim to edit a file somewhere in the 'path'.

- `:ls` or `:buffers` view the buffer list.
- `:bnext`		go to next buffer
- `:bprevious`	go to previous buffer
- `:bfirst`		go to the first buffer
- `:blast`		go to the last buffer

## usr24.txt Inserting quickly

- `CTRL-N` search forward
- `CTRL-P` search backward

- `CTRL-A` inserts the text you typed the last time you were in Insert mode.
- `CTRL-Y` inserts the character above the cursor.
- `CTRL-R {register}` inserts the contents of the register.


- `CTRL-O {command}` you can execute any Normal mode command from Insert mode.

## usr25.txt Editing formatted text

- `gq{motion}` Format the lines that {motion} moves over.

- `:{range}center [width]` Center a range of lines.  {range} is the usual command-line range.  [width] is an optional line width to use for centering.  If [width] is not specified, it defaults to the value of 'textwidth'.  (If 'textwidth' is 0, the default is 80.)

- `:1,5right 37` right-justifies the text.

- `set virtualedit=all` Now you can move the cursor to positions where there isn't any text.  This is called "virtual space".  Editing a table is a lot easier this way.
- `:set virtualedit=` Go back to non-virtual cursor movements with: >

## usr26.txt Repeating

- `CTRL-A` Add [count] to the number or alphabetic character at or after the cursor.
- `CTRL-X` Subtract [count] from the number or alphabetic character at or after the cursor.

- `:args *.c` Put all the relevant files in the argument list.

- `:argdo %s/\<x_cnt\>/x_counter/ge | update` takes an argument that is another command.

- `ls | vim -` This allows you to edit the output of the "ls" command, without first saving the text in a file.

## usr27.txt Search commands and patterns

- `/default/2` `/const/e` `/const/e+1` By default, the search command leaves the cursor positioned on the beginning of the pattern.  You can tell Vim to leave it some other place by specifying an offset.  For the forward search command "/", the offset is specified by appending a slash (/) and the offset.

## usr29.txt Moving through programs

- `[[` To move to the start of the outer block.
- `][` To move to the end of the outer block.
- `[{` Moves to the start of the current block.
- `]}` Moves to the end of the current block.

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

