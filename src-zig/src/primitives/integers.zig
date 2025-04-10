const std = @import("std");
const Endian = std.builtin.Endian;

/// Reads an unsigned 16-bit integer.
pub fn readU16(source: []const u8, endian: Endian) u16 {
    return std.mem.readInt(u16, source[0..2], endian);
}

/// Reads a signed 16-bit integer.
pub fn readI16(source: []const u8, endian: Endian) i16 {
    return std.mem.readInt(i16, source[0..2], endian);
}

/// Reads an unsigned 24-bit integer.
pub fn readU24(source: []const u8, endian: Endian) u24 {
    return std.mem.readInt(u24, source[0..3], endian);
}

/// Reads a signed 24-bit integer.
pub fn readI24(source: []const u8, endian: Endian) i24 {
    return std.mem.readInt(i24, source[0..3], endian);
}

/// Reads an unsigned 32-bit integer.
pub fn readU32(source: []const u8, endian: Endian) u32 {
    return std.mem.readInt(u32, source[0..4], endian);
}

/// Reads a signed 32-bit integer.
pub fn readI32(source: []const u8, endian: Endian) i32 {
    return std.mem.readInt(i32, source[0..4], endian);
}

/// Reads an unsigned 64-bit integer.
pub fn readU64(source: []const u8, endian: Endian) u64 {
    return std.mem.readInt(u64, source[0..8], endian);
}

/// Reads a signed 64-bit integer.
pub fn readI64(source: []const u8, endian: Endian) i64 {
    return std.mem.readInt(i64, source[0..8], endian);
}

/// Reads an unsigned 128-bit integer.
pub fn readU128(source: []const u8, endian: Endian) u128 {
    return std.mem.readInt(u128, source[0..16], endian);
}

/// Reads a signed 128-bit integer.
pub fn readI128(source: []const u8, endian: Endian) i128 {
    return std.mem.readInt(i128, source[0..16], endian);
}

/// Writes an unsigned 16-bit integer.
pub fn writeU16(dest: []u8, value: u16, endian: Endian) void {
    std.mem.writeInt(u16, dest[0..2], value, endian);
}

/// Writes a signed 16-bit integer.
pub fn writeI16(dest: []u8, value: i16, endian: Endian) void {
    std.mem.writeInt(i16, dest[0..2], value, endian);
}

/// Writes an unsigned 24-bit integer.
pub fn writeU24(dest: []u8, value: u24, endian: Endian) void {
    std.mem.writeInt(u24, dest[0..3], value, endian);
}

/// Writes a signed 24-bit integer.
pub fn writeI24(dest: []u8, value: i24, endian: Endian) void {
    std.mem.writeInt(i24, dest[0..3], value, endian);
}

/// Writes an unsigned 32-bit integer.
pub fn writeU32(dest: []u8, value: u32, endian: Endian) void {
    std.mem.writeInt(u32, dest[0..4], value, endian);
}

/// Writes a signed 32-bit integer.
pub fn writeI32(dest: []u8, value: i32, endian: Endian) void {
    std.mem.writeInt(i32, dest[0..4], value, endian);
}

/// Writes an unsigned 64-bit integer.
pub fn writeU64(dest: []u8, value: u64, endian: Endian) void {
    std.mem.writeInt(u64, dest[0..8], value, endian);
}

/// Writes a signed 64-bit integer.
pub fn writeI64(dest: []u8, value: i64, endian: Endian) void {
    std.mem.writeInt(i64, dest[0..8], value, endian);
}

/// Writes an unsigned 128-bit integer.
pub fn writeU128(dest: []u8, value: u128, endian: Endian) void {
    std.mem.writeInt(u128, dest[0..16], value, endian);
}

/// Writes a signed 128-bit integer.
pub fn writeI128(dest: []u8, value: i128, endian: Endian) void {
    std.mem.writeInt(i128, dest[0..16], value, endian);
}

test readU16 {
    var data = [_]u8{ 0x00, 0x01 };
    try std.testing.expectEqual(1, readU16(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readU16(&data, .little));
}

test readI16 {
    var data = [_]u8{ 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI16(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(-2, readI16(&data, .little));
}

test readU24 {
    var data = [_]u8{ 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU24(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readU24(&data, .little));
}

test readI24 {
    var data = [_]u8{ 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI24(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(-2, readI24(&data, .little));
}

test readU32 {
    var data = [_]u8{ 0x00, 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU32(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readU32(&data, .little));
}

test readI32 {
    var data = [_]u8{ 0xff, 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI32(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(-2, readI32(&data, .little));
}

test readU64 {
    var data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU64(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readU64(&data, .little));
}

test readI64 {
    var data = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI64(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(-2, readI64(&data, .little));
}

test readU128 {
    var data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU128(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readU128(&data, .little));
}

test readI128 {
    var data = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI128(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(-2, readI128(&data, .little));
}

test writeU16 {
    var expected = [_]u8{ 0x00, 0x01 };
    var data: [2]u8 = undefined;

    writeU16(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeU16(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeI16 {
    var expected = [_]u8{ 0xff, 0xfe };
    var data: [2]u8 = undefined;

    writeI16(&data, -2, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeI16(&data, -2, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeU24 {
    var expected = [_]u8{ 0x00, 0x00, 0x01 };
    var data: [3]u8 = undefined;

    writeU24(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeU24(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeI24 {
    var expected = [_]u8{ 0xff, 0xff, 0xfe };
    var data: [3]u8 = undefined;

    writeI24(&data, -2, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeI24(&data, -2, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeU32 {
    var expected = [_]u8{ 0x00, 0x00, 0x00, 0x01 };
    var data: [4]u8 = undefined;

    writeU32(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeU32(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeI32 {
    var expected = [_]u8{ 0xff, 0xff, 0xff, 0xfe };
    var data: [4]u8 = undefined;

    writeI32(&data, -2, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeI32(&data, -2, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeU64 {
    var expected = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    var data: [8]u8 = undefined;

    writeU64(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeU64(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeI64 {
    var expected = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    var data: [8]u8 = undefined;

    writeI64(&data, -2, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeI64(&data, -2, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeU128 {
    var expected = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    var data: [16]u8 = undefined;

    writeU128(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeU128(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeI128 {
    var expected = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    var data: [16]u8 = undefined;

    writeI128(&data, -2, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeI128(&data, -2, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}
