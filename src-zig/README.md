# BinaryPrimitiveHelpers

## Installation

Add BinaryPrimitiveHelpers as a submodule:

```sh
mkdir libs
git submodule add https://github.com/carlst99/BinaryPrimitiveHelpers libs/BinaryPrimitiveHelpers
```

And in `build.zig`, import it against your own modules:

```zig
my_module.addAnonymousImport("binary_primitive_helpers", .{
    .root_source_file = b.path("libs/BinaryPrimitiveHelpers/src-zig/src/root.zig"),
});
```

And import it in your code using the following:

```zig
const binary_primitive_helpers = @import("binary_primitive_helpers");
```