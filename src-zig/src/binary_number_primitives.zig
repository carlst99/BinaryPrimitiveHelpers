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

/// Reads a 16-bit floating-point number (half) in big endian form.
pub fn readF16BE(source: []const u8) f16 {
    const value: i16 = readI16BE(source);
    return @bitCast(value);
}

/// Reads a 16-bit floating-point number (half) in little endian form.
pub fn readF16LE(source: []const u8) f16 {
    const value: i16 = readI16LE(source);
    return @bitCast(value);
}

/// Reads a 32-bit floating-point number (single) in big endian form.
pub fn readF32BE(source: []const u8) f32 {
    const value: i32 = readI32BE(source);
    return @bitCast(value);
}

/// Reads a 32-bit floating-point number (single) in little endian form.
pub fn readF32LE(source: []const u8) f32 {
    const value: i32 = readI32LE(source);
    return @bitCast(value);
}

/// Reads a 64-bit floating-point number (double) in big endian form.
pub fn readF64BE(source: []const u8) f64 {
    const value: i64 = readI64BE(source);
    return @bitCast(value);
}

/// Reads a 64-bit floating-point number (double) in little endian form.
pub fn readF64LE(source: []const u8) f64 {
    const value: i64 = readI64LE(source);
    return @bitCast(value);
}

/// Writes an unsigned 16-bit integer in big endian form.
pub fn writeU16BE(dest: []u8, value: u16) void {
    dest[0] = @truncate(value >> 8);
    dest[1] = @truncate(value);
}

/// Writes an unsigned 24-bit integer in big endian form.
pub fn writeU24BE(dest: []u8, value: u24) void {
    dest[0] = @truncate(value >> 16);
    dest[1] = @truncate(value >> 8);
    dest[2] = @truncate(value);
}

/// Writes an unsigned 32-bit integer in big endian form.
pub fn writeU32BE(dest: []u8, value: u32) void {
    dest[0] = @truncate(value >> 24);
    dest[1] = @truncate(value >> 16);
    dest[2] = @truncate(value >> 8);
    dest[3] = @truncate(value);
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

test readF16BE {
    const data = [_]u8{ 0x3c, 0x00 };
    try std.testing.expectEqual(1, readF16BE(&data));
}

test readF16LE {
    const data = [_]u8{ 0x00, 0x3c };
    try std.testing.expectEqual(1, readF16LE(&data));
}

test readF32BE {
    const data = [_]u8{ 0x42, 0xAA, 0x40, 0x00 };
    try std.testing.expectEqual(85.125, readF32BE(&data));
}

test readF32LE {
    const data = [_]u8{ 0x00, 0x40, 0xAA, 0x42 };
    try std.testing.expectEqual(85.125, readF32LE(&data));
}

test readF64BE {
    const data = [_]u8{ 0x40, 0x55, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00 };
    try std.testing.expectEqual(85.125, readF64BE(&data));
}

test readF64LE {
    const data = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x48, 0x55, 0x40 };
    try std.testing.expectEqual(85.125, readF64LE(&data));
}

test writeU16BE {
    var data: [2]u8 = undefined;
    writeU16BE(&data, std.math.maxInt(u16));
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xFF, 0xFF }, &data);
}

test writeU24BE {
    var data: [3]u8 = undefined;
    writeU24BE(&data, std.math.maxInt(u24) - 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xFF, 0xFF, 0xFE }, &data);
}

test writeU32BE {
    var data: [4]u8 = undefined;
    writeU32BE(&data, std.math.maxInt(u32));
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0xFF, 0xFF, 0xFF, 0xFF }, &data);
}
