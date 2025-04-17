const std = @import("std");
const BphError = @import("root.zig").BphError;
const Endian = std.builtin.Endian;
const number_prims = @import("primitives/numbers.zig");
const string_prims = @import("primitives/strings.zig");

/// A sequential reader of primitives from binary data.
/// This type does not perform explicit bounds checks.
const BinaryPrimitiveReader = @This();

/// The underlying slice of binary data.
buffer: []const u8,
/// The offset into the slice that the reader is at.
offset: usize = 0,

pub fn init(slice: []const u8) BinaryPrimitiveReader {
    return BinaryPrimitiveReader{ .buffer = slice };
}

/// Advances the offset of the reader by the given amount.
pub inline fn advance(self: *BinaryPrimitiveReader, amount: usize) BphError!void {
    if (self.offset + amount >= self.buffer.len) return BphError.EndOfStream;
    self.offset += amount;
}

/// Gets a slice over the underlying data that has been consumed.
pub fn getConsumed(self: BinaryPrimitiveReader) []const u8 {
    return self.buffer[0..self.offset];
}

/// Gets a slice over the underlying data that is remaining to be consumed.
pub fn getRemaining(self: BinaryPrimitiveReader) []const u8 {
    return self.buffer[self.offset..];
}

pub fn readBytes(self: *BinaryPrimitiveReader, len: usize) BphError![]const u8 {
    if (self.offset + len > self.buffer.len) return BphError.EndOfStream;
    const value = self.buffer[self.offset .. self.offset + len];
    self.offset += len;
    return value;
}

pub fn readU8(self: *BinaryPrimitiveReader) BphError!u8 {
    if (self.offset >= self.buffer.len) return BphError.EndOfStream;
    self.offset += 1;
    return self.buffer[self.offset - 1];
}

/// Reads an integer value.
pub fn readInt(self: *BinaryPrimitiveReader, comptime T: type, endian: Endian) BphError!T {
    const value = number_prims.readInt(T, self.buffer[self.offset..], endian) catch return BphError.EndOfStream;
    self.offset += @divExact(@typeInfo(T).int.bits, 8);
    return value;
}

/// Reads a floating-point value.
pub fn readFloat(self: *BinaryPrimitiveReader, comptime T: type, endian: Endian) BphError!T {
    const value = number_prims.readFloat(T, self.buffer[self.offset..], endian) catch return BphError.EndOfStream;
    self.offset += @divExact(@typeInfo(T).float.bits, 8);
    return value;
}

/// Reads a boolean value. Zero is treated as false, One as true, and all other values as errors.
pub fn readBool(self: *BinaryPrimitiveReader) BphError!bool {
    return switch (try self.readU8()) {
        0 => false,
        1 => true,
        else => BphError.NonBooleanValue,
    };
}

/// Reads a null-terminated string, returning a slice over the underlying buffer.
pub fn readStringNullTerminated(self: *BinaryPrimitiveReader) BphError![:0]const u8 {
    const value = try string_prims.readStringNullTerminated(self.buffer[self.offset..]);
    self.offset += value.len + 1; // +1 as .len does not include the sentinel
    return value;
}

pub const BRStringAllocError = BphError || error{OutOfMemory};

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

test advance {
    const data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveReader.init(&data);

    try reader.advance(2);
    try std.testing.expectEqual(2, reader.offset);
    try reader.advance(1);
    try std.testing.expectEqual(3, reader.offset);

    try std.testing.expectError(BphError.EndOfStream, reader.advance(1));
}

test getConsumed {
    const data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveReader.init(&data);
    try reader.advance(2);

    try std.testing.expectEqual(data[0..2], reader.getConsumed());
}

test getRemaining {
    const data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveReader.init(&data);
    try reader.advance(2);

    try std.testing.expectEqual(data[2..4], reader.getRemaining());
}

test readBytes {
    const data = [_]u8{ 0x1, 0xFF, 0xAA };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqualSlices(u8, data[0..2], try reader.readBytes(2));
    try std.testing.expectEqualSlices(u8, data[2..3], try reader.readBytes(1));

    try std.testing.expectError(BphError.EndOfStream, reader.readBytes(1));
}

test readU8 {
    const data = [_]u8{ 0x1, 0xFF };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(0x1, reader.readU8());
    try std.testing.expectEqual(0xFF, reader.readU8());

    try std.testing.expectError(BphError.EndOfStream, reader.readU8());
}

test readInt {
    const data = [_]u8{ 0x00, 0x01, 0xfe, 0xff };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(1, reader.readInt(u16, .big));
    try std.testing.expectEqual(-2, reader.readInt(i16, .little));

    try std.testing.expectError(
        BphError.EndOfStream,
        reader.readInt(u8, .big),
    );
}

test readFloat {
    const data = [_]u8{ 0x3c, 0x00, 0x00, 0x3c };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(1, reader.readFloat(f16, .big));
    try std.testing.expectEqual(1, reader.readFloat(f16, .little));

    try std.testing.expectError(
        BphError.EndOfStream,
        reader.readFloat(f16, .big),
    );
}

test readBool {
    const data = [_]u8{ 0x0, 0x1, 0xFF };
    var reader = BinaryPrimitiveReader.init(&data);

    try std.testing.expectEqual(false, reader.readBool());
    try std.testing.expectEqual(true, reader.readBool());
    try std.testing.expectError(BphError.NonBooleanValue, reader.readBool());

    try std.testing.expectError(BphError.EndOfStream, reader.readBool());
}

test readStringNullTerminated {
    const data = "test\x00String";
    // Coerce to slice with sentinel included
    var reader = BinaryPrimitiveReader.init(data[0 .. data.len + 1]);
    try std.testing.expectEqualStrings("test", try reader.readStringNullTerminated());
    try std.testing.expectEqualStrings("String", try reader.readStringNullTerminated());
    // Nothing left. We should expect a no-terminator found
    try std.testing.expectError(
        BphError.StringNotTerminated,
        reader.readStringNullTerminated(),
    );

    // We should error out on data that doesn't have a null-terminator
    const data2 = "ab";
    var reader2 = BinaryPrimitiveReader.init(data2);
    try std.testing.expectError(
        BphError.StringNotTerminated,
        reader2.readStringNullTerminated(),
    );
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

    // Nothing left. We should expect a no-terminator found
    try std.testing.expectError(
        BphError.StringNotTerminated,
        reader.readStringNullTerminatedWithAlloc(std.testing.allocator),
    );

    // We should error out on data that doesn't have a null-terminator
    const data2 = [_]u8{ 'A', 'B' };
    var reader2 = BinaryPrimitiveReader.init(&data2);
    try std.testing.expectError(
        BphError.StringNotTerminated,
        reader2.readStringNullTerminated(),
    );
}
