pub const integer_primitives = @import("primitives/integers.zig");
pub const float_primitives = @import("primitives/floats.zig");
pub const BinaryPrimitiveReader = @import("BinaryPrimitiveReader.zig");
pub const BinaryPrimitiveWriter = @import("BinaryPrimitiveWriter.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
