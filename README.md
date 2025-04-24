# Binary Primitive Helpers

I often find myself working with binary data, and have lost count of the number of times I've copied the same
utility classes and functions between various projects. These utilities help with reading and writing primitive
data (e.g. numbers and strings) from a byte array.

For my own convenience, I've consolidated these utilities into this repository, in both a Zig and .NET library.
It's important to note that any functions which read or write binary data should perform bounds-checks.

See further details in the README for each language:
- [Zig](./src-zig/README.md)
- [.NET](./src-cs/README.md)
