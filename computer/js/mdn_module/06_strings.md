# JavaScript Modules

## 6 Strings

### Single quotes vs. double quotes

1. There is very little difference between the two, and which you use is down to personal preference. You should choose one and stick to it, however; differently quoted code can be confusing, especially if you use two different quotes on the same string!

2. The browser will think the string has not been closed because the other type of quote you are not using to contain your strings can appear in the string.

### Concatenating strings

1. The `Number` object converts anything passed to it into a number.（伍注：`Number()` 其实是调用了Number类的构造函数？）

2. Every number has a method called `toString()` that converts it to the equivalent string.

### Template literals

1. Template literals provides more flexible, easier to read strings. To turn a standard string literal into a template literal, you have to replace the quote marks (' ', or " ") with backtick characters (` `).
```
output = `I like the song "${ song }". I gave it a score of ${ score/highestScore * 100 }%.`;
```

2. Template literals respect the line breaks in the source code, so newline characters are no longer needed.
