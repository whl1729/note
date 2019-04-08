# 《C++ Primer》第17章读书笔记

## 17 Specialized Library Facilities

### The tuple Type

1. A tuple is most useful when we want to combine some data into a single object but do not want to bother to define a data structure to represent those data. A tuple can be thought of as a “quick and dirty” data structure.

2. Operations on tuples
```
tuple<T1, T2, ..., Tn> t;
tuple<T1, T2, ..., Tn> t(v1, v2, ..., vn);
make_tuple(v1, v2, ..., vn)
t1 == t2
t1 != t2
t1 relop t2  // The tuples must have the same number of members
get<i>(t)  // All members of a tuple are public
tuple_size<tupleType>::value
tuple_element<i, tupleType>::type
```

3. Because tuple defines the < and == operators, we can pass sequences of tuples to the algorithms and can use a tuple as key type in an ordered container.

4. A common use of tuple is to return multiple values from a function. 

### The bitset Type

1. The standard library defines the bitset class to make it easier to use bit operations and possible to deal with collections of bits that are larger than the longest integral type. The bitset class is a class template that has a fixed size.

2. Ways to Initialize a bitset
```
bitset<n> b;  // b has n bits; each bit is 0.
bitset<n> b(u);  // b is a copy of the n low-order bits of unsigned long long value u. If n is greater than the size of an unsigned long long, the high-order bits beyond those in the unsigned long long are set to zero.
bitset<n> b(s, pos, m, zero, one);
bitset<n> b(cp, pos, m, zero, one);
```

3. The indexing conventions of strings and bitsets are inversely related: The character in the string with the highest subscript (the rightmost character) is used to initialize the low-order bit in the bitset (the bit with subscript 0). When you initialize a bitset from a string, it is essential to remember this difference.

4. bitset Operations
```
b.any()  // Is any bit in b on?
b.all()  // Are all the bits in b on?
b.none() // Are no bits in b on?
b.count()  // Number of bits in b that are on.
b.size() // Number of bits in b
b.test(pos)
b.set(pos, v)  // v defaults to true
b.set()  // turns on all the bits in b.
b.reset(pos)  // turns off the bit at position pos
b.reset()
b.flip(pos) // Changes the state of the bit at position pos
b.flip()
b[pos]  // if b is const, then b[pos] return a bool value
b.to_ulong()
b.to_ullong()
b.to_string(zero, one)
os << b
os >> b
```

5. The to_ulong and to_ullong operations throw an overflow_error exception if the value in the bitset does not fit in the specified type.

### Regular Expressions

1. Regular Expression Library Components
    - regex
    - regex_match: returns true if the entire input sequence matches the expression.
    - regex_search: returns true if there is a substring in the input sequence that matches.
    - regex_replace
    - sregex_iterator
    - smatch
    - ssub_match

2. regex (and wregex) Operations
```
regex r(re)
regex r(re, f)  // f means Flags, which defaults to ECMAScript
r1 = re
r1.assign(re, f)
r.mark_count()
r.flags()
// Flags Specified  When a regex Is Defined
icase   // Ignore case during the match
nosubs  // Don't store subexpression matches
optimize  // Favor speed of execution over speed of construction
ECMAScript
basic
extended
awk
grep
egrep
```

3. Arguments to regex_search and regex_match
```
// seq: can be a string, a pair of iterators, a pointer to a character array
// m: a match object
// r: regex object
// mft: an optional regex_constants::match_flag_type value
(seq, m, r, mft)
(seq, r, mft)
```

4. The syntactic correctness of a regular expression is evaluated at run time.

5. regex_error: If we make a mistake in writing a regular expression, then at run time the library will throw an exception of type regex_error. Like the standard exception types, regex_error has 
    - a what operation that describes the error that occurred. 
    - a member named code that returns a numeric code corresponding to the type of error that was encountered.

6. Regular Expression Error Conditions
```
error_collate
error_ctype
error_escape
error_backref
error_brack
error_paren
error_brace
error_badbrace
error_range
error_space
error_badrepeat
error_complexity
error_stack
```

7. Advice: Avoid Creating Unnecessary Regular Expressions
    - Compiling a regular expression can be a surprisingly slow operation, especially if you’re using the extended regular-expression grammar or are using complicated expressions. 
    - To minimize this overhead, you should try to avoid creating more regex objects than needed. 
    - In particular, if you use a regular expression in a loop, you should create it outside the loop rather than recompiling it on each iteration.

8. The RE library types we use must match the type of the input sequence
If Input Sequence Has Type | Use Regular Expression Classes
-------------------------- | ----------------------------------------
string           | regex, smatch, ssub_match, and sregex_iterator
const char\*     | regex, cmatch, csub_match, and cregex_iterator
wstring          | wregex, wsmatch, wssub_match, and wsregex_iterator
const wchar_t\*  | wregex, wcmatch, wcsub_match, and wcregex_iterator

9. sregex_iterator Operations
    - When we bind an sregex_iterator to a string and a regex object, the iterator is automatically positioned on the first match in the given string. That is, the sregex_iterator constructor calls regex_search on the given string and regex. 
    - When we dereference the iterator, we get an smatch object corresponding to the results from the most recent search. 
    - When we increment the iterator, it calls regex_search to find the next match in the input string.
```
// These operations also apply to cregex_iterator, wsregex_iterator, and wcregex_iterator
sregex_iterator it(b, e, r);
sregex_iterator end;
*it
it->
++it
it++
it1 == it2
it1 != it2
```

10. smatch Operations
```
// These operations also apply to the cmatch, wsmatch, wcmatch and
// the corresponding csub_match, wssub_match, and wcsub_match types.
m.ready()
m.size()
m.empty()
m.prefix()
m.suffix()
m.formmat(...)
m.length(n)
m.position(n)
m.str(n)  // str(0) represents the overall match
m[n]
m.begin(), m.end()
m.cbegin(), m.cend()
```

11. Whenever we group alternatives using parentheses, we are also declaring that those alternatives form a subexpression.

12. One common use for subexpressions is to validate data that must match a specific format.

13. ECMAScript regular-expression language:
    - \{d} represents a single digit and \{d}{n} represents a sequence of n digits. (E.g., \{d}{3} matches a sequence of three digits.) 
    - A collection of characters inside square brackets allows a match to any of those characters. 
    - A component followed by ’?’ is optional. 
    - Like C++, ECMAScript uses a backslash to indicate that a character should represent itself, rather than its special meaning. 

14. Submatch Operations
```
matched
first   // iterator to the start of the matching sequence
second  // iterator to the one past the end of the matching sequence
length()  // The size of this match. Return 0 if matched is false
str()   // Returns the empty string() if matched is false
s = ssub  // Equivalent to s = ssub.str()
```

15. We refer to a particular subexpression by using a $ symbol followed by the index number for a subexpression. 注意：使用子表达式前，一定要确保正则表达式的相应部分已经用括号括起来了，如果某部分没用括号括起来，则不会被视为子表达式，可能会导致$n对应的子表达式与预期不符。
```
string fmt = "$2.$5.$7"; // reformat numbers to ddd.ddd.dddd
```

16. Regular Expression Replace Operations
```
m.format(dest, fmt, mft)
m.format(fmt, mft)
regex_replace(dest, seq, r, fmt, mft)
regex_replace(seq, r, fmt, mft)
```

17. Match Flags
```
// Defined in regex_constants::match_flag_type
match_default
match_not_bol
match_not_eol
match_not_bow
match_not_eow
match_any
match_not_null
match_continuous
match_pre_avail
format_default
format_sed
format_no_copy  // Don't output the unmatched parts of the input
format_first_only
```

18. Like placeholders, which we used with bind, regex_constants is a namespace defined inside the std namespace. To use a name from regex_constants, we must qualify that name with the names of both namespaces:
```
using std::regex_constants::format_no_copy;
// or
using namespace std::regex_constants;
```

### Random Numbers

1. Random Number Library Components
    - Engine: Types that generate a sequence of random unsigned integers
    - Distribution: Types that use an engine to return numbers according to a particular probability distribution

2. Best Practices:: C++ programs should not use the library rand function. Instead, they should use the default_random_engine along with an appropriate distribution object.

3. The library defines several random-number engines that differ in terms of their performance and quality of randomness. Each compiler designates one of these engines as the default_random_engine type. 

4. Random Number Engine Operations
```
Engine e;
Engine e(s);
e.seed(s)
e.min()
e.max()
Engine::result_type
e.discard(u)
```

5. When we refer to a random-number generator, we mean the combination of a distribution object with an engine.

6. Warning: A given random-number generator always produces the same sequence of numbers. A function with a local random-number generator should make that generator (both the engine and distribution objects) static. Otherwise, the function will generate the identical sequence on each call.

7. Seeding a Generator
    - Perhaps the most common approach is to call the system time function. This function, defined in the ctime header, returns the number of seconds since a given epoch. The time function takes a single parameter that is a pointer to a structure into which to write the time. If that pointer is null, the function just returns the time.
    - Warning: Using time as a seed usually doesn’t work if the program is run repeatedly as part of an automated process; it might wind up with the same seed several times.

8. Distribution Operations
```
Dist d;
d(e); // e is a random-number engine object
d.min()
d.max()
d.reset()
```

9. Using the Distribution’s Default Result Type
    - Each distribution template has a default template argument. The distribution types that generate floating-point values generate double by default. Distributions that generate integral results use int as their default. 
    - When we want to use the default we must remember to follow the template’s name with empty angle brackets to signify that we want the default  

10. The bernoulli_distribution class is an ordinary class rather than a template. This distribution always returns a bool value. It returns true with a given probability. By default that probability is 0.5.

11. Warning: Because engines return the same sequence of numbers, it is essential that we declare engines outside of loops. Otherwise, we’d create a new engine on each iteration and generate the same values on each iteration. Similarly, distributions may retain state and should also be defined outside loops.

### The IO Library Revisited

1. manipulators
    - A manipulator is a function or object that affects the state of a stream and can be used as an operand to an input or output operator.
    - A manipulator returns the stream object to which it is applied, so we can combine manipulators and data in a single statement.
    - Manipulators are used for two broad categories of output control: controlling the presentation of numeric values and controlling the amount and placement of padding.

2. Manipulators Defined in iostream
```
boolalpha  // Display true and false as strings. Default : noboolalpha
showbase   // Generate prefix indicating the numeric base of integral values. Default: noshowbase
showpoint  // Always display a decimal point for floating-point values. Default: noshowpoint
showpos  // Display + in nonnegative numbers. Default: noshowpos
uppercase // Print 0X in hexadecimal, E in scientific. Default: nouppercase
dec, hex, oct // Display integral values in decimal, hexadecimal or octal numeric base. Default: dec
left   // Add fill characters to the right of the value
right  // Add fill characters to the left of the value
internal  // Add fill characters between the sign and the value
fixed  // Display floating-point values in decimal notation
scientific  // Display floating-point values in scientific nptation
hexfloat  // Display floating-point values in hex. use "defaultfloat" to reset
unitbuf  // Flush buffers after every output operation. Default: nounitbuf
noskipws   // Do not skip whitespace with input operators. Default: skipws
flush  // Flush the ostream buffer
ends   // Insert null, then flush the ostream buffer
endl   // Insert newline, then flush the ostream buffer
```

3. Manipulators Defined in iomanip
```
setfill(ch)      // Fill whitespace with ch
setprecision(n)  // Set floating-point precision to n
setw(w)          // Read or write value to w characters
setbase(b)       // Output integers in base b
```

4. Manipulators that change the format state of the stream usually leave the format state changed for all subsequent IO. It is usually best to undo whatever state changes are made as soon as those changes are no longer needed.

5. The hex, oct, and dec manipulators affect only integral operands; the representation of floating-point values is unaffected.

6. The default format of Floating-Point Values
    - floating-point values are printed using six digits of precision; 
    - the decimal point is omitted if the value has no fractional part;
    - and they are printed in either fixed decimal or scientific notation depending on the value of the number. The library chooses a format that enhances readability of the number. Very large and very small values are printed using scientific notation. Other values are printed in fixed decimal.

7. setprecision
    - When printed, floating-point values are rounded, not truncated, to the current precision.
    - We can change the precision by calling the precision member of an IO object or by using the setprecision manipulator. 
    - The precision member is overloaded. One version takes an int value and sets the precision to that new value. It returns the previous precision value. The other version takes no arguments and returns the current precision value. 
    - The setprecision manipulator takes an argument, which it uses to set the precision.

8. After executing scientific, fixed, or hexfloat, the precision value controls the number of digits after the decimal point. By default, precision specifies the total number of digits—both before and after the decimal point.

9. setw, like endl, does not change the internal state of the output stream. It determines the size of only the next output.

10. By default, the input operators ignore whitespace (blank, tab, newline, formfeed, and carriage return). The noskipws manipulator causes the input operator to read, rather than skip, whitespace. To return to the default behavior, we apply the skipws manipulator.

11. Single-Byte Low-Level IO Operations
```
is.get(ch)  // Return is
os.put(ch)  // Return os
is.get()    // Return next byte from is as an int
is.putback(ch)  // Put the character ch back on is; returns is.
is.unget()  // Move is back one byte; return is.
is.peek()   // Return the next byte as an int but doesn't remove it.
```

12. In general, we are guaranteed to be able to put back at most one value before the next read. That is, we are not guaranteed to be able to call putback or unget successively without an intervening read operation.

13. the iostream header defines a const named EOF that we can use to test if the value returned from get is end-of-file. It is essential that we use an int to hold the return from these functions.

14. Multi-Byte Low-Level IO Operations
```
is.get(sink, size, delim)  // leaves the delim as the next char of the istream
is.getline(sink, size, delim)  // reads and discard the delim
is.read(sink, size)
is.gcout()  // Returns number of bytes read from the stream is by the last call to an unformatted read operation.
os.write(source, size)
is.ignore(size, delim)  // Reads and ignores at most size characters up to and including delim. size defaults to 1 and delim defaults to EOF.
```

15. The get and getline functions read until one of the following conditions occurs:
    - size - 1 characters are read
    - End-of-file is encounteredC++ Primer, Fifth Edition
    - The delimiter character is encountered

16. Warning: It is a common error to intend to remove the delimiter from the stream but to forget to do so.

17. Caution: It is a common programming error to assign the return, from get or peek to a char rather than an int.

18. Random IO is an inherently system-dependent. To understand how to use these features, you must consult your system’s documentation.

19. On most systems, the streams bound to cin, cout, cerr, and clog do not support random access.

20. Seek and Tell Functions
```
tellg()  // g means "getting"
tellp()  // p means "putting"
seekg(pos)
seekp(pos)
seekp(off, from)  // from can be one of beg, cur or end
seekg(off, from)
```

21. Note: Because there is only a single marker, we must do a seek to reposition the marker whenever we switch between reading and writing.

### Question:

1. sregex_search是最长匹配的吗？ 答：从试验结果来看是的。
