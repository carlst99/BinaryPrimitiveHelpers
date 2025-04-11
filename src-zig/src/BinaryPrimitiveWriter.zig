const BphError = @import("root.zig").BphError;
const Endian = std.builtin.Endian;
const number_prims = @import("primitives/numbers.zig");
const std = @import("std");

/// A sequential writer of primitives to binary data.
/// This type does not perform explicit bounds checks.
const BinaryPrimitiveWriter = @This();

/// The underlying slice of binary data.
buffer: []u8,
/// The offset into the slice that the reader is at.
offset: usize = 0,

pub fn init(slice: []u8) BinaryPrimitiveWriter {
    return BinaryPrimitiveWriter{ .buffer = slice };
}

/// Advances the offset of the writer by the given amount.
pub fn advance(self: *BinaryPrimitiveWriter, amount: usize) void {
    self.offset += amount;
}

pub fn getConsumed(self: BinaryPrimitiveWriter) []u8 {
    return self.buffer[0..self.offset];
}

pub fn getRemaining(self: BinaryPrimitiveWriter) []u8 {
    return self.buffer[self.offset..];
}

/// Writes a byte value
pub fn writeU8(self: *BinaryPrimitiveWriter, value: u8) !void {
    if (self.offset >= self.buffer.len) return BphError.EndOfStream;
    self.buffer[self.offset] = value;
    self.offset += @sizeOf(u8);
}

pub fn writeInt(self: *BinaryPrimitiveWriter, comptime T: type, value: T, endian: Endian) BphError!void {
    try number_prims.writeInt(T, self.buffer[self.offset..], value, endian);
    self.offset += @divExact(@typeInfo(T).int.bits, 8);
}

/// Writes a boolean value. False is treated as a zero, and true as a one.
pub fn writeBool(self: *BinaryPrimitiveWriter, value: bool) BphError!void {
    try self.writeU8(switch (value) {
        false => 0,
        true => 1,
    });
}

pub fn writeBytes(self: *BinaryPrimitiveWriter, value: []const u8) void {
    @memcpy(self.buffer[self.offset .. self.offset + value.len], value);
    self.offset += value.len;
}

/// Writes a null-terminated string.
pub fn writeStringNullTerminated(self: *BinaryPrimitiveWriter, value: [:0]const u8) void {
    @memcpy(
        self.buffer[self.offset .. self.offset + value.len + 1],
        value[0 .. value.len + 1],
    );
    self.offset += value.len + 1;
}

test writeU8 {
    var data: [2]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeU8(0x1);
    try writer.writeU8(0xFF);

    try std.testing.expectEqual(0x1, data[0]);
    try std.testing.expectEqual(0xFF, data[1]);
}

test writeInt {
    var data: [4]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeInt(u16, 1, .big);
    try writer.writeInt(i16, -2, .little);

    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x01 }, data[0..2]);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xfe, 0xff }, data[2..4]);
}

test writeBool {
    var data: [2]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeBool(false);
    try writer.writeBool(true);

    try std.testing.expectEqual(0, data[0]);
    try std.testing.expectEqual(1, data[1]);
}

test writeBytes {
    var data: [4]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    writer.writeBytes(&[_]u8{ 2, 4 });
    writer.writeBytes(&[_]u8{ 6, 8 });

    try std.testing.expectEqualSlices(u8, &[_]u8{ 2, 4, 6, 8 }, &data);
}

test writeStringNullTerminated {
    var data: [12]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    writer.writeStringNullTerminated("test");
    writer.writeStringNullTerminated("String");

    // Coerce string to slice with sentinel included
    try std.testing.expectEqualSlices(u8, "test\x00String"[0..12], &data);
}
