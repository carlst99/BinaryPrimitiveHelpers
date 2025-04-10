# Binary Primitive Helpers

> [!NOTE]
> 🚧 This repo is heavily in development. 🚧

I often find myself working with binary data, and have lost count of the number of times I've copied the same
utility classes and functions between various projects. These utilities help with reading and writing primitive
data (e.g. numbers and strings) from a byte array.

For my own convenience, I've consolidated these utilities into this repository, in both a Zig and .NET library.
Where possible, I abstract functions of each language's standard library, in order to benefit from any safety
checks and optimisations they perform.

Safety of these abstractions is an important note to make - I generally do not add any checks. These helpers
should be as low ceremony (and ideally fast) as possible - do your own checks or let the compiler/standard library
take care of it! For example, bounds checks - .NET will perform these, and Zig will do them when building in `Debug`
or `ReleaseSafe` mode.