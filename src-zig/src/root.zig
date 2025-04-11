pub const BinaryPrimitiveReader = @import("BinaryPrimitiveReader.zig");
pub const BinaryPrimitiveWriter = @import("BinaryPrimitiveWriter.zig");
pub const number_primitives = @import("primitives/numbers.zig");

pub const BphError = error{
    /// The provided buffer was too small to read/write the requested data type.
    EndOfStream,

    /// An invalid boolean value was read.
    NonBooleanValue,

    /// A terminator byte could not be found when attempting to read a string value.
    StringNotTerminated,
};

test {
    @import("std").testing.refAllDecls(@This());
}
