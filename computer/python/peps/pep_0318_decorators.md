# PEP 318 -- Decorators for Functions and Methods

## Current Syntax

1. The current syntax for function decorators as implemented in Python 2.4a2 is:
```
@dec2
@dec1
def func(arg1, arg2, ...):
    pass
```

This is equivalent to:

```
def func(arg1, arg2, ...):
    pass
func = dec2(dec1(func))
```

## References

1. [PEP 318 -- Decorators for Functions and Methods](https://www.python.org/dev/peps/pep-0318/)
2. [7. Decorators](https://book.pythontips.com/en/latest/decorators.html)
