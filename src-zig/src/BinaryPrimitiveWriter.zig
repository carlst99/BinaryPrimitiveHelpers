const std = @import("std");
const BphError = @import("root.zig").BphError;
const Endian = std.builtin.Endian;
const number_prims = @import("primitives/numbers.zig");
const string_prims = @import("primitives/strings.zig");

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
pub inline fn advance(self: *BinaryPrimitiveWriter, amount: usize) BphError!void {
    if (self.offset + amount > self.buffer.len) return BphError.EndOfStream;
    self.offset += amount;
}

/// Gets a slice over the underlying data that has been consumed.
pub fn getConsumed(self: BinaryPrimitiveWriter) []u8 {
    return self.buffer[0..self.offset];
}

/// Gets a slice over the underlying data that is remaining to be consumed.
pub fn getRemaining(self: BinaryPrimitiveWriter) []u8 {
    return self.buffer[self.offset..];
}

/// Gets the remaining number of bytes that can be read from the underlying data.
pub fn getRemainingLen(self: BinaryPrimitiveWriter) usize {
    return self.buffer.len - self.offset;
}

pub fn writeBytes(self: *BinaryPrimitiveWriter, value: []const u8) BphError!void {
    if (self.offset + value.len > self.buffer.len) return BphError.EndOfStream;
    @memcpy(self.buffer[self.offset .. self.offset + value.len], value);
    self.offset += value.len;
}

/// Writes a byte value
pub fn writeU8(self: *BinaryPrimitiveWriter, value: u8) BphError!void {
    if (self.offset >= self.buffer.len) return BphError.EndOfStream;
    self.buffer[self.offset] = value;
    self.offset += @sizeOf(u8);
}

/// Writes an integer value.
pub fn writeInt(self: *BinaryPrimitiveWriter, comptime T: type, value: T, endian: Endian) BphError!void {
    number_prims.writeInt(T, self.buffer[self.offset..], value, endian) catch return BphError.EndOfStream;
    self.offset += @divExact(@typeInfo(T).int.bits, 8);
}

/// Writes a floating-point value.
pub fn writeFloat(self: *BinaryPrimitiveWriter, comptime T: type, value: T, endian: Endian) BphError!void {
    number_prims.writeFloat(T, self.buffer[self.offset..], value, endian) catch return BphError.EndOfStream;
    self.offset += @divExact(@typeInfo(T).float.bits, 8);
}

/// Writes a boolean value. False is treated as a zero, and true as a one.
pub fn writeBool(self: *BinaryPrimitiveWriter, value: bool) BphError!void {
    try self.writeU8(switch (value) {
        false => 0,
        true => 1,
    });
}

/// Writes a null-terminated string.
pub fn writeStringNullTerminated(self: *BinaryPrimitiveWriter, value: [:0]const u8) BphError!void {
    string_prims.writeStringNullTerminated(self.buffer[self.offset..], value) catch return BphError.EndOfStream;
    self.offset += value.len + 1; // Add one, as len does not include the sentinel
}

test advance {
    var data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveWriter.init(&data);

    try reader.advance(2);
    try std.testing.expectEqual(2, reader.offset);
    try reader.advance(2);
    try std.testing.expectEqual(4, reader.offset);

    try std.testing.expectError(BphError.EndOfStream, reader.advance(1));
}

test getConsumed {
    var data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveWriter.init(&data);
    try reader.advance(2);

    try std.testing.expectEqual(data[0..2], reader.getConsumed());
}

test getRemaining {
    var data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveWriter.init(&data);
    try reader.advance(2);

    try std.testing.expectEqual(data[2..4], reader.getRemaining());
}

test getRemainingLen {
    var data = [_]u8{ 0x1, 0xFF, 0xAA, 0xBB };
    var reader = BinaryPrimitiveWriter.init(&data);
    try reader.advance(2);

    try std.testing.expectEqual(2, reader.getRemainingLen());
}

test writeBytes {
    var data: [4]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeBytes(&[_]u8{ 2, 4 });
    try writer.writeBytes(&[_]u8{ 6, 8 });

    try std.testing.expectEqualSlices(u8, &[_]u8{ 2, 4, 6, 8 }, &data);

    try std.testing.expectError(
        BphError.EndOfStream,
        writer.writeBytes(&[_]u8{6}),
    );
}

test writeU8 {
    var data: [2]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeU8(0x1);
    try writer.writeU8(0xFF);

    try std.testing.expectEqual(0x1, data[0]);
    try std.testing.expectEqual(0xFF, data[1]);

    try std.testing.expectError(
        BphError.EndOfStream,
        writer.writeU8(2),
    );
}

test writeInt {
    var data: [4]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeInt(u16, 1, .big);
    try writer.writeInt(i16, -2, .little);

    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x01 }, data[0..2]);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xfe, 0xff }, data[2..4]);

    try std.testing.expectError(
        BphError.EndOfStream,
        writer.writeInt(u8, 1, .big),
    );
}

test writeFloat {
    var data: [4]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);

    try writer.writeFloat(f16, 1, .big);
    try writer.writeFloat(f16, 1, .little);

    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x3c, 0x00 }, data[0..2]);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x3c }, data[2..4]);

    try std.testing.expectError(
        BphError.EndOfStream,
        writer.writeFloat(f16, 1, .big),
    );
}

test writeBool {
    var data: [2]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeBool(false);
    try writer.writeBool(true);

    try std.testing.expectEqual(0, data[0]);
    try std.testing.expectEqual(1, data[1]);

    try std.testing.expectError(
        BphError.EndOfStream,
        writer.writeBool(true),
    );
}

test writeStringNullTerminated {
    var data: [12]u8 = undefined;
    var writer = BinaryPrimitiveWriter.init(&data);
    try writer.writeStringNullTerminated("test");
    try writer.writeStringNullTerminated("String");

    // Coerce string to slice with sentinel included
    try std.testing.expectEqualSlices(u8, "test\x00String"[0..12], &data);

    try std.testing.expectError(
        BphError.EndOfStream,
        writer.writeStringNullTerminated("a"),
    );
}
