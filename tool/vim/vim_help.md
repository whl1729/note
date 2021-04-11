# vim help 学习笔记

## usr_02.txt The first steps in Vim

- `J` join two lines together

- `ZZ` writes the file and exits

- `:help index` get a complete index of all Vim commands

- `:tab h` open help document in a full window

## usr_03.txt Moving around

- `CTRL-U` command scrolls down half a screen of text.
- `CTRL-D` command scrolls up half a screen of text.
- `CTRL-E` Scroll window [count] lines downwards in the buffer.
- `CTRL-Y` Scroll window [count] lines upwards in the buffer.

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

## usr30.txt Editing programs

- `==` indents the current line.
- `=a{` indents the current {} block.

## usr32.txt The undo tree

- `g-` Go to older text state.  With a count repeat that many times.
- `g+` Go to newer text state.  With a count repeat that many times.

## usr40.txt Make new commands

- `:map` defines remapping for keys in Normal mode. You can also define mappings for other modes. For example, ":imap" applies to Insert mode.
- `:noremap` To avoid keys to be mapped again.
- `:command` To list the user-defined commands.

## tips.txt

1. renaming files
```
	$ vim
	:r !ls *.c
	:%s/\(.*\).c/mv & \1.bla
	:w !sh
	:q!
```

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


## editing.txt

- `[count]gf` Edit the file whose name is under or after the cursor. Mnemonic: "goto file".

## motion.txt

- `CTRL-O` Go to [count] Older cursor position in jump list
- `CTRL-I` Go to [count] newer cursor position in jump list

- `g;` Go to [count] older position in change list.
- `g,` Go to [count] newer cursor position in change list.

- `g^` When lines wrap ('wrap' on): To the first non-blank character of the screen line.
- `g$` When lines wrap ('wrap' on): To the last character of the screen line and [count - 1] screen lines downward inclusive.
- `F{char}` To the [count]'th occurrence of {char} to the left.
- `t{char}` Till before [count]'th occurrence of {char} to the right.  The cursor is placed on the character left of {char} |inclusive|.
- `T{char}`	Till after [count]'th occurrence of {char} to the left.  The cursor is placed on the character right of {char} |exclusive|.

- `H` To line [count] from top (Home) of window on the first non-blank character.
- `M` To Middle line of window, on the first non-blank character.
- `L` To line [count] from bottom of window on the first non-blank character.

- `%` Find the next item in this line after or under the cursor and jump to its match. Items can be: `([{}])`, `/* */`,  `#if, #ifdef, #else, #elif, #endif`

- `(` [count] sentences backward.  |exclusive| motion.
- `)` [count] sentences forward.  |exclusive| motion.
- `{` [count] paragraphs backward.  |exclusive| motion.
- `}` [count] paragraphs forward.  |exclusive| motion.
- `]]` [count] sections forward or to the next '{' in the first column.
- `][` [count] sections forward or to the next '}' in the first column.
- `[[` [count] sections backward or to the previous '{' in the first column.
- `[]` [count] sections backward or to the previous '}' in the first column.

- `[(` go to [count] previous unmatched '('.
- `[{` go to [count] previous unmatched '{'.
- `])` go to [count] next unmatched ')'.
- `]}` go to [count] next unmatched '}'.

- `aw` "a word", select [count] words.  Leading or trailing white space is included, but not counted.
- `iw` "inner word", select [count] words.  White space between words is counted too.
- `aW` "a WORD", select [count] WORDs.  Leading or trailing white space is included, but not counted.
- `as` "a sentence", select [count] sentences
- `is` "inner sentence", select [count] sentences
- `ap` "a paragraph", select [count] paragraphs
- `ip` "inner paragraph", select [count] paragraphs
- `a]` or `a[` "a [] block", select [count] '[' ']' blocks.

## insert.txt

- `CTRL-C` or `CTRL-[` Quit insert mode, go back to Normal mode.

## change.txt

- `CTRL-A` Add [count] to the number or alphabetic character at or after the cursor.
- `{Visual}CTRL-A` Add [count] to the number or alphabetic character in the highlighted text.
- `CTRL-X` Subtract [count] from the number or alphabetic character at or after the cursor.
- `{Visual}CTRL-X` Subtract [count] from the number or alphabetic character in the highlighted text.

- `["x]p` Put the text [from register x] after the cursor [count] times.
- `["x]P` Put the text [from register x] before the cursor [count] times.
- `["x]gp` Just like "p", but leave the cursor just after the new text.
- `["x]gP` Just like "P", but leave the cursor just after the new text.

- `!{motion}{filter}` Filter {motion} text lines through the external program {filter}.
- `!!{filter}` 	Filter [count] lines through the external program {filter}.
- `{Visual}!{filter}` Filter the highlighted lines through the external program {filter}.
- `:{range}![!]{filter} [!][arg]` Filter {range} lines through the external program {filter}.


- `:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]` For each line in [range] replace a match of {pattern} with {string}.

- `:reg[isters]` Display the contents of all numbered and named registers.

- `["x]gp` Just like "p", but leave the cursor just after the new text.

- `["x]gP` Just like "P", but leave the cursor just after the new text.

## repeat.txt

- `@:` Repeat last command-line [count] times.

## cmdline.txt

- Use `CTRL-P` to go through the list in the other direction in command line completion.
- type "=" and press <Tab>:  What happens here is that Vim inserts the old value of the option.  Now you can edit it.
- When there are many matches, you would like to see an overview.  Do this by pressing `CTRL-D`.
- `q:` Open the command line window.
- `:his[tory]` Print the history of last entered commands.

## options.txt

- `:se[t]` Show all options that differ from their default value.
- `:se[t] all` Show all but terminal options.
- `:se[t] termcap` Show all terminal options.
- `:se[t] {option}?` Show value of {option}.
- `:se[t] {option}` Toggle option: set, switch it on.  Number option: show value.  String option: show value.
- `:se[t] no{option}` Toggle option: Reset, switch it off.

## pattern.txt

- `*` Search forward for the [count]'th occurrence of the word nearest to the cursor. Only whole keywords are searched for, like with the command "/\<keyword\>".
- `#` Same as "\*", but search backward.
- `g*` Like "\*", but don't put "\<" and "\>" around the word.
- `g#` Like "#", but don't put "\<" and "\>" around the word.
- `gd` Goto local Declaration.

- `\+` Matches 1 or more of the preceding atom, as many as possible.
- `\=` Matches 0 or 1 of the preceding atom, as many as possible.
- `\{n,m}` Matches n to m of the preceding atom, as many as possible
- `\{n}` Matches n of the preceding atom
- `\{n,}` Matches at least n of the preceding atom, as many as possible
- `\{,m}` Matches 0 to m of the preceding atom, as many as possible

- `\_^`	Matches start-of-line.
- `\_$`	Matches end-of-line.
- `\%^`	Matches start of the file.
- `\%$`	Matches end of the file.

## map.txt

Overview of which map command works in which mode.  More details below.
     COMMANDS                    MODES ~
:map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
:nmap  :nnoremap :nunmap    Normal
:vmap  :vnoremap :vunmap    Visual and Select
:smap  :snoremap :sunmap    Select
:xmap  :xnoremap :xunmap    Visual
:omap  :onoremap :ounmap    Operator-pending
:map!  :noremap! :unmap!    Insert and Command-line
:imap  :inoremap :iunmap    Insert
:lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
:cmap  :cnoremap :cunmap    Command-line
:tmap  :tnoremap :tunmap    Terminal-Job

## tagsrch.txt

- `CTRL-]` Jump to the definition of the keyword under the cursor.
- `CTRL-T` Jump to [count] older entry in the tag stack

- `[i` Display the first line that contains the keyword under the cursor.  The search starts at the beginning of the file.
- `]i` like "[i", but start at the current cursor position.
- `[I` Display all lines that contain the keyword under the cursor.  Filenames and line numbers are displayed for the found lines.  The search starts at the beginning of the file.
- `]I` like "[I", but start at the current cursor position.
- `[ CTRL-I` Jump to the first line that contains the keyword under the cursor. The search starts at the beginning of the file.
- `] CTRL-I` like "\[ CTRL-I", but start at the current cursor position.
- `CTRL-W CTRL-I` or `CTRL-W i` Open a new window, with the cursor on the first line that contains the keyword under the cursor.

- `:ts[elect][!] [ident]` List the tags that match [ident], using the information in the tags file(s).  When [ident] is not given, the last tag name from the tag stack is used.
- `g]` Like CTRL-], but use ":tselect" instead of ":tag".

## quickfix.txt

- A location list is a window-local quickfix list. You get one after commands like `:lvimgrep`, `:lgrep`, `:lhelpgrep`, `:lmake`, etc., which create a location list instead of a quickfix list as the corresponding `:vimgrep`, `:grep`, `:helpgrep`, `:make` do.

- `:cc[!] [nr]`	Display error [nr]. If [nr] is omitted, the same error is displayed again.
- `:ll[!] [nr]`	Same as ":cc", except the location list for the current window is used instead of the quickfix list.

- `:[count]cn[ext][!]` Display the [count] next error in the list that includes a file name.  If there are no file names at all, go to the [count] next error.
- `:[count]lne[xt][!]` Same as ":cnext", except the location list for the current window is used instead of the quickfix list.

- `:[count]cN[ext][!]` or `:[count]cp[revious][!]` Display the [count] previous error in the list that includes a file name. If there are no file names at all, go to the [count] previous error.
- `:[count]lN[ext][!]` or `:[count]lp[revious][!]` Same as ":cNext" and ":cprevious", except the location list for the current window is used instead of the quickfix list.

- `:cl[ist]! [from] [, [to]]` List all errors.
- `:lli[st]! [from] [, [to]]` List all the entries in the location list for the current window.
- `:cdo[!] {cmd}` Execute {cmd} in each valid entry in the quickfix list.

- `:cope[n] [height]` Open a window to show the current list of errors.
- `:lop[en] [height]` Open a window to show the location list for the current window.

- `:ccl[ose]` Close the quickfix window.
- `:lcl[ose]` Close the window showing the location list for the current window.

## diff.txt

- `vimdiff file1 file2 [file3 [file4]]` or `vim -d file1 file2 [file3 [file4]]` This starts Vim as usual, and additionally sets up for viewing the differences between the arguments. >

