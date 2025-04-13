# BinaryPrimitiveHelpers

## Installation

Use `zig fetch` on the command line to retrieve BinaryPrimitivHelpers as a dependency.

```sh
zig fetch https://github.com/carlst99/BinaryPrimitiveHelpers/archive/<COMMIT>.tar.gz --save
```

Now, add the module in `build.zig`, and import it against your own modules:

```zig
const opts = .{ .target = target, .optimize = optimize };
const bin_prim_helpers = b.dependency("binary_primitive_helpers", opts).module("binary_primitive_helpers");

exe.root_module.addImport("binary_primitive_helpers", bin_prim_helpers);
```