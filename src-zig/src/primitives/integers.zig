const std = @import("std");

/// Reads an unsigned 16-bit integer in big endian form.
pub fn readU16BE(source: []const u8) u16 {
    return std.mem.readInt(u16, source[0..2], .big);
}

/// Reads an unsigned 16-bit integer in little endian form.
pub fn readU16LE(source: []const u8) u16 {
    return std.mem.readInt(u16, source[0..2], .little);
}

/// Reads a signed 16-bit integer in big endian form.
pub fn readI16BE(source: []const u8) i16 {
    return std.mem.readInt(i16, source[0..2], .big);
}

/// Reads a signed 16-bit integer in little endian form.
pub fn readI16LE(source: []const u8) i16 {
    return std.mem.readInt(i16, source[0..2], .little);
}

/// Reads an unsigned 24-bit integer in big endian form.
pub fn readU24BE(source: []const u8) u24 {
    return std.mem.readInt(u24, source[0..3], .big);
}

/// Reads an unsigned 24-bit integer in little endian form.
pub fn readU24LE(source: []const u8) u24 {
    return std.mem.readInt(u24, source[0..3], .little);
}

/// Reads a signed 24-bit integer in big endian form.
pub fn readI24BE(source: []const u8) i24 {
    return std.mem.readInt(i24, source[0..3], .big);
}

/// Reads a signed 24-bit integer in little endian form.
pub fn readI24LE(source: []const u8) i24 {
    return std.mem.readInt(i24, source[0..3], .little);
}

/// Reads an unsigned 32-bit integer in big endian form.
pub fn readU32BE(source: []const u8) u32 {
    return std.mem.readInt(u32, source[0..4], .big);
}

/// Reads an unsigned 32-bit integer in little endian form.
pub fn readU32LE(source: []const u8) u32 {
    return std.mem.readInt(u32, source[0..4], .little);
}

/// Reads a signed 32-bit integer in big endian form.
pub fn readI32BE(source: []const u8) i32 {
    return std.mem.readInt(i32, source[0..4], .big);
}

/// Reads a signed 32-bit integer in little endian form.
pub fn readI32LE(source: []const u8) i32 {
    return std.mem.readInt(i32, source[0..4], .little);
}

/// Reads an unsigned 64-bit integer in big endian form.
pub fn readU64BE(source: []const u8) u64 {
    return std.mem.readInt(u64, source[0..8], .big);
}

/// Reads an unsigned 64-bit integer in little endian form.
pub fn readU64LE(source: []const u8) u64 {
    return std.mem.readInt(u64, source[0..8], .little);
}

/// Reads a signed 64-bit integer in big endian form.
pub fn readI64BE(source: []const u8) i64 {
    return std.mem.readInt(i64, source[0..8], .big);
}

/// Reads a signed 64-bit integer in little endian form.
pub fn readI64LE(source: []const u8) i64 {
    return std.mem.readInt(i64, source[0..8], .little);
}

/// Reads an unsigned 128-bit integer in big endian form.
pub fn readU128BE(source: []const u8) u128 {
    return std.mem.readInt(u128, source[0..16], .big);
}

/// Reads an unsigned 128-bit integer in little endian form.
pub fn readU128LE(source: []const u8) u128 {
    return std.mem.readInt(u128, source[0..16], .little);
}

/// Reads a signed 128-bit integer in big endian form.
pub fn readI128BE(source: []const u8) i128 {
    return std.mem.readInt(i128, source[0..16], .big);
}

/// Reads a signed 128-bit integer in little endian form.
pub fn readI128LE(source: []const u8) i128 {
    return std.mem.readInt(i128, source[0..16], .little);
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

test readU16BE {
    const data = [_]u8{ 0x00, 0x01 };
    try std.testing.expectEqual(1, readU16BE(&data));
}

test readU16LE {
    const data = [_]u8{ 0x01, 0x00 };
    try std.testing.expectEqual(1, readU16LE(&data));
}

test readI16BE {
    const data = [_]u8{ 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI16BE(&data));
}

test readI16LE {
    const data = [_]u8{ 0xfe, 0xff };
    try std.testing.expectEqual(-2, readI16LE(&data));
}

test readU24BE {
    const data = [_]u8{ 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU24BE(&data));
}

test readU24LE {
    const data = [_]u8{ 0x01, 0x00, 0x00 };
    try std.testing.expectEqual(1, readU24LE(&data));
}

test readI24BE {
    const data = [_]u8{ 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI24BE(&data));
}

test readI24LE {
    const data = [_]u8{ 0xfe, 0xff, 0xff };
    try std.testing.expectEqual(-2, readI24LE(&data));
}

test readU32BE {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU32BE(&data));
}

test readU32LE {
    const data = [_]u8{ 0x01, 0x00, 0x00, 0x00 };
    try std.testing.expectEqual(1, readU32LE(&data));
}

test readI32BE {
    const data = [_]u8{ 0xff, 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI32BE(&data));
}

test readI32LE {
    const data = [_]u8{ 0xfe, 0xff, 0xff, 0xff };
    try std.testing.expectEqual(-2, readI32LE(&data));
}

test readU64BE {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU64BE(&data));
}

test readU64LE {
    const data = [_]u8{ 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    try std.testing.expectEqual(1, readU64LE(&data));
}

test readI64BE {
    const data = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI64BE(&data));
}

test readI64LE {
    const data = [_]u8{ 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
    try std.testing.expectEqual(-2, readI64LE(&data));
}

test readU128BE {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 };
    try std.testing.expectEqual(1, readU128BE(&data));
}

test readU128LE {
    const data = [_]u8{ 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    try std.testing.expectEqual(1, readU128LE(&data));
}

test readI128BE {
    const data = [_]u8{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe };
    try std.testing.expectEqual(-2, readI128BE(&data));
}

test readI128LE {
    const data = [_]u8{ 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
    try std.testing.expectEqual(-2, readI128LE(&data));
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
