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

/// Writes an unsigned 16-bit integer in big endian form.
pub fn writeU16BE(dest: []u8, value: u16) void {
    std.mem.writeInt(u16, dest[0..2], value, .big);
}

/// Writes an unsigned 16-bit integer in little endian form.
pub fn writeU16LE(dest: []u8, value: u16) void {
    std.mem.writeInt(u16, dest[0..2], value, .little);
}

/// Writes a signed 16-bit integer in big endian form.
pub fn writeI16BE(dest: []u8, value: i16) void {
    std.mem.writeInt(i16, dest[0..2], value, .big);
}

/// Writes a signed 16-bit integer in little endian form.
pub fn writeI16LE(dest: []u8, value: i16) void {
    std.mem.writeInt(i16, dest[0..2], value, .little);
}

/// Writes an unsigned 24-bit integer in big endian form.
pub fn writeU24BE(dest: []u8, value: u24) void {
    std.mem.writeInt(u24, dest[0..3], value, .big);
}

/// Writes an unsigned 24-bit integer in little endian form.
pub fn writeU24LE(dest: []u8, value: u24) void {
    std.mem.writeInt(u24, dest[0..3], value, .little);
}

/// Writes a signed 24-bit integer in big endian form.
pub fn writeI24BE(dest: []u8, value: i24) void {
    std.mem.writeInt(i24, dest[0..3], value, .big);
}

/// Writes a signed 24-bit integer in little endian form.
pub fn writeI24LE(dest: []u8, value: i24) void {
    std.mem.writeInt(i24, dest[0..3], value, .little);
}

/// Writes an unsigned 32-bit integer in big endian form.
pub fn writeU32BE(dest: []u8, value: u32) void {
    std.mem.writeInt(u32, dest[0..4], value, .big);
}

/// Writes an unsigned 32-bit integer in little endian form.
pub fn writeU32LE(dest: []u8, value: u32) void {
    std.mem.writeInt(u32, dest[0..4], value, .little);
}

/// Writes a signed 32-bit integer in big endian form.
pub fn writeI32BE(dest: []u8, value: i32) void {
    std.mem.writeInt(i32, dest[0..4], value, .big);
}

/// Writes a signed 32-bit integer in little endian form.
pub fn writeI32LE(dest: []u8, value: i32) void {
    std.mem.writeInt(i32, dest[0..4], value, .little);
}

/// Writes an unsigned 64-bit integer in big endian form.
pub fn writeU64BE(dest: []u8, value: u64) void {
    std.mem.writeInt(u64, dest[0..8], value, .big);
}

/// Writes an unsigned 64-bit integer in little endian form.
pub fn writeU64LE(dest: []u8, value: u64) void {
    std.mem.writeInt(u64, dest[0..8], value, .little);
}

/// Writes a signed 64-bit integer in big endian form.
pub fn writeI64BE(dest: []u8, value: i64) void {
    std.mem.writeInt(i64, dest[0..8], value, .big);
}

/// Writes a signed 64-bit integer in little endian form.
pub fn writeI64LE(dest: []u8, value: i64) void {
    std.mem.writeInt(i64, dest[0..8], value, .little);
}

/// Writes an unsigned 128-bit integer in big endian form.
pub fn writeU128BE(dest: []u8, value: u128) void {
    std.mem.writeInt(u128, dest[0..16], value, .big);
}

/// Writes an unsigned 128-bit integer in little endian form.
pub fn writeU128LE(dest: []u8, value: u128) void {
    std.mem.writeInt(u128, dest[0..16], value, .little);
}

/// Writes a signed 128-bit integer in big endian form.
pub fn writeI128BE(dest: []u8, value: i128) void {
    std.mem.writeInt(i128, dest[0..16], value, .big);
}

/// Writes a signed 128-bit integer in little endian form.
pub fn writeI128LE(dest: []u8, value: i128) void {
    std.mem.writeInt(i128, dest[0..16], value, .little);
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

test writeU16BE {
    var data: [2]u8 = undefined;
    writeU16BE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x01 }, &data);
}

test writeU16LE {
    var data: [2]u8 = undefined;
    writeU16LE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x01, 0x00 }, &data);
}

test writeI16BE {
    var data: [2]u8 = undefined;
    writeI16BE(&data, -2);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xff, 0xfe }, &data);
}

test writeI16LE {
    var data: [2]u8 = undefined;
    writeI16LE(&data, -2);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xfe, 0xff }, &data);
}

test writeU24BE {
    var data: [3]u8 = undefined;
    writeU24BE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x00, 0x01 }, &data);
}

test writeU24LE {
    var data: [3]u8 = undefined;
    writeU24LE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x01, 0x00, 0x00 }, &data);
}

test writeI24BE {
    var data: [3]u8 = undefined;
    writeI24BE(&data, -2);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xff, 0xff, 0xfe }, &data);
}

test writeI24LE {
    var data: [3]u8 = undefined;
    writeI24LE(&data, -2);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xfe, 0xff, 0xff }, &data);
}

test writeU32BE {
    var data: [4]u8 = undefined;
    writeU32BE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x00, 0x00, 0x01 }, &data);
}

test writeU32LE {
    var data: [4]u8 = undefined;
    writeU32LE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x01, 0x00, 0x00, 0x00 }, &data);
}

test writeI32BE {
    var data: [4]u8 = undefined;
    writeI32BE(&data, -2);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xff, 0xff, 0xff, 0xfe }, &data);
}

test writeI32LE {
    var data: [4]u8 = undefined;
    writeI32LE(&data, -2);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xfe, 0xff, 0xff, 0xff }, &data);
}

test writeU64BE {
    var data: [8]u8 = undefined;
    writeU64BE(&data, 1);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 },
        &data,
    );
}

test writeU64LE {
    var data: [8]u8 = undefined;
    writeU64LE(&data, 1);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
        &data,
    );
}

test writeI64BE {
    var data: [8]u8 = undefined;
    writeI64BE(&data, -2);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe },
        &data,
    );
}

test writeI64LE {
    var data: [8]u8 = undefined;
    writeI64LE(&data, -2);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
        &data,
    );
}

test writeU128BE {
    var data: [16]u8 = undefined;
    writeU128BE(&data, 1);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 },
        &data,
    );
}

test writeU128LE {
    var data: [16]u8 = undefined;
    writeU128LE(&data, 1);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
        &data,
    );
}

test writeI128BE {
    var data: [16]u8 = undefined;
    writeI128BE(&data, -2);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe },
        &data,
    );
}

test writeI128LE {
    var data: [16]u8 = undefined;
    writeI128LE(&data, -2);
    try std.testing.expectEqualSlices(
        u8,
        &[_]u8{ 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
        &data,
    );
}
