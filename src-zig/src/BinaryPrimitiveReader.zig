const integer_primitives = @import("primitives/integers.zig");
const std = @import("std");
const Endian = std.builtin.Endian;

/// A sequential reader of primitives from binary data.
/// This type does not perform explicit bounds checks.
const BinaryPrimitiveReader = @This();

const BinaryPrimitiveReaderError = error{
    NonBooleanValue,
    StringNotTerminated,
};

/// The underlying slice of binary data.
buffer: []const u8,
/// The offset into the slice that the reader is at.
offset: usize = 0,

pub fn init(slice: []const u8) BinaryPrimitiveReader {
    return BinaryPrimitiveReader{ .buffer = slice };
}

/// Advances the offset of the reader by the given amount.
pub inline fn advance(self: *BinaryPrimitiveReader, amount: usize) void {
    self.offset += amount;
}

/// Reads an unsigned 8-bit value
pub fn readU8(self: *BinaryPrimitiveReader) u8 {
    self.offset += 1;
    return self.buffer[self.offset - 1];
}

// Reads a signed 8-bit integer.
pub fn readI8(self: *BinaryPrimitiveReader) i8 {
    self.offset += 1;
    return @bitCast(self.buffer[self.offset - 1]);
}

/// Reads an unsigned 16-bit integer.
pub fn readU16(self: *BinaryPrimitiveReader, endian: Endian) u16 {
    self.offset += 2;
    return integer_primitives.readU16(self.buffer[self.offset - 2 ..], endian);
}

/// Reads a signed 16-bit integer.
pub fn readI16(self: *BinaryPrimitiveReader, endian: Endian) i16 {
    self.offset += 2;
    return integer_primitives.readI16(self.buffer[self.offset - 2 ..], endian);
}

/// Reads an unsigned 24-bit integer.
pub fn readU24(self: *BinaryPrimitiveReader, endian: Endian) u24 {
    self.offset += 3;
    return integer_primitives.readU24(self.buffer[self.offset - 3 ..], endian);
}

/// Reads a signed 24-bit integer.
pub fn readI24(self: *BinaryPrimitiveReader, endian: Endian) i24 {
    self.offset += 3;
    return integer_primitives.readI24(self.buffer[self.offset - 3 ..], endian);
}

/// Reads an unsigned 32-bit integer.
pub fn readU32(self: *BinaryPrimitiveReader, endian: Endian) u32 {
    self.offset += 4;
    return integer_primitives.readU32(self.buffer[self.offset - 4 ..], endian);
}

/// Reads a signed 32-bit integer.
pub fn readI32(self: *BinaryPrimitiveReader, endian: Endian) i32 {
    self.offset += 4;
    return integer_primitives.readI32(self.buffer[self.offset - 4 ..], endian);
}

/// Reads an unsigned 64-bit integer.
pub fn readU64(self: *BinaryPrimitiveReader, endian: Endian) u64 {
    self.offset += 8;
    return integer_primitives.readU64(self.buffer[self.offset - 8 ..], endian);
}

/// Reads a signed 64-bit integer.
pub fn readI64(self: *BinaryPrimitiveReader, endian: Endian) i64 {
    self.offset += 8;
    return integer_primitives.readI64(self.buffer[self.offset - 8 ..], endian);
}

/// Reads an unsigned 128-bit integer.
pub fn readU128(self: *BinaryPrimitiveReader, endian: Endian) u128 {
    self.offset += 16;
    return integer_primitives.readU128(self.buffer[self.offset - 16 ..], endian);
}

/// Reads a signed 128-bit integer.
pub fn readI128(self: *BinaryPrimitiveReader, endian: Endian) i128 {
    self.offset += 16;
    return integer_primitives.readI128(self.buffer[self.offset - 16 ..], endian);
}

/// Reads a boolean value. Zero is treated as false, One as true, and all other values as errors.
pub fn readBool(self: *BinaryPrimitiveReader) BinaryPrimitiveReaderError!bool {
    return switch (self.readU8()) {
        0 => false,
        1 => true,
        else => BinaryPrimitiveReaderError.NonBooleanValue,
    };
}

/// Reads a null-terminated string, returning a slice over the underlying buffer.
pub fn readStringNullTerminated(self: *BinaryPrimitiveReader) BinaryPrimitiveReaderError![:0]const u8 {
    // Get the index of the first null-terminator (sentinel) past our offset
    const sentinel = [_]u8{0};
    const index = std.mem.indexOf(u8, self.buffer[self.offset..], &sentinel);

    // Error out if std.mem.indexOf() could not find the sentinel value
    if (index == null) {
        return BinaryPrimitiveReaderError.StringNotTerminated;
    }

    const sentinel_offset = self.offset + index.?;
    // Take a slice between our offsets, and imply the presence of a sentinel
    const value: [:0]const u8 = self.buffer[self.offset..sentinel_offset :0];

    self.offset = sentinel_offset + 1;
    return value;
}

pub const BRStringAllocError = BinaryPrimitiveReaderError || error{OutOfMemory};

/// Reads a null-terminated string, returning an allocated copy.
pub fn readStringNullTerminatedWithAlloc(
    self: *BinaryPrimitiveReader,
    allocator: std.mem.Allocator,
) BRStringAllocError![:0]const u8 {
    // Get the string as a slice over the source buffer
    const string_buffer = try self.readStringNullTerminated();

    // Allocate a sentinel slice for the string.
    const value = try allocator.allocSentinel(u8, string_buffer.len, 0);

    // Coerce both slices to non-sentinel, and copy the string into the allocated space
    @memcpy(value[0 .. value.len + 1], string_buffer[0 .. value.len + 1]);
    return value;
}

test readU8 {
    const data = [_]u8{ 0x1, 0xFF };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(0x1, reader.readU8());
    try std.testing.expectEqual(0xFF, reader.readU8());
}

test readI8 {
    const data = [_]u8{ 0x01, 0xFF };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(1, reader.readI8());
    try std.testing.expectEqual(-1, reader.readI8());
}

test readU16 {
    const data = [_]u8{ 0x00, 0x01, 0x01, 0x00 };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(1, reader.readU16(.big));
    try std.testing.expectEqual(1, reader.readU16(.little));
}

test readI16 {
    const data = [_]u8{ 0xff, 0xfe, 0xfe, 0xff };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(-2, reader.readI16(.big));
    try std.testing.expectEqual(-2, reader.readI16(.little));
}

test readU24 {
    const data = [_]u8{ 0x00, 0x00, 0x01, 0x01, 0x00, 0x00 };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(1, reader.readU24(.big));
    try std.testing.expectEqual(1, reader.readU24(.little));
}

test readI24 {
    const data = [_]u8{ 0xff, 0xff, 0xfe, 0xfe, 0xff, 0xff };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(-2, reader.readI24(.big));
    try std.testing.expectEqual(-2, reader.readI24(.little));
}

test readU32 {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00 };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(1, reader.readU32(.big));
    try std.testing.expectEqual(1, reader.readU32(.little));
}

test readI32 {
    const data = [_]u8{ 0xff, 0xff, 0xff, 0xfe, 0xfe, 0xff, 0xff, 0xff };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(-2, reader.readI32(.big));
    try std.testing.expectEqual(-2, reader.readI32(.little));
}

test readU64 {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    var data2 = data ++ data;
    std.mem.reverse(u8, data2[8..]);

    var reader = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectEqual(1, reader.readU64(.big));
    try std.testing.expectEqual(1, reader.readU64(.little));
}

test readI64 {
    const data = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    var data2 = data ++ data;
    std.mem.reverse(u8, data2[8..]);

    var reader = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectEqual(-2, reader.readI64(.big));
    try std.testing.expectEqual(-2, reader.readI64(.little));
}

test readU128 {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    var data2 = data ++ data;
    std.mem.reverse(u8, data2[16..]);

    var reader = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectEqual(1, reader.readU128(.big));
    try std.testing.expectEqual(1, reader.readU128(.little));
}

test readI128 {
    const data = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    var data2 = data ++ data;
    std.mem.reverse(u8, data2[16..]);

    var reader = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectEqual(-2, reader.readI128(.big));
    try std.testing.expectEqual(-2, reader.readI128(.little));
}

test readBool {
    const data = [_]u8{ 0x0, 0x1, 0xFF };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(false, reader.readBool());
    try std.testing.expectEqual(true, reader.readBool());
    try std.testing.expectError(BinaryPrimitiveReaderError.NonBooleanValue, reader.readBool());
}

test readStringNullTerminated {
    const data = "test\x00String";
    // Coerce to slice with sentinel included
    var reader = BinaryPrimitiveReader.init(data[0 .. data.len + 1]);
    try std.testing.expectEqualStrings("test", try reader.readStringNullTerminated());
    try std.testing.expectEqualStrings("String", try reader.readStringNullTerminated());

    // We should error out on data that doesn't have a null-terminator
    const data2 = [_]u8{ 'A', 'B' };
    var reader2 = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectError(BinaryPrimitiveReaderError.StringNotTerminated, reader2.readStringNullTerminated());
}

test readStringNullTerminatedWithAlloc {
    const data = "test\x00String";
    // Coerce to slice with sentinel included
    var reader = BinaryPrimitiveReader.init(data[0 .. data.len + 1]);

    const result = try reader.readStringNullTerminatedWithAlloc(std.testing.allocator);
    defer std.testing.allocator.free(result);
    try std.testing.expectEqualStrings("test", result);

    const result2 = try reader.readStringNullTerminatedWithAlloc(std.testing.allocator);
    defer std.testing.allocator.free(result2);
    try std.testing.expectEqualStrings("String", result2);

    // We should error out on data that doesn't have a null-terminator
    const data2 = [_]u8{ 'A', 'B' };
    var reader2 = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectError(BinaryPrimitiveReaderError.StringNotTerminated, reader2.readStringNullTerminated());
}
