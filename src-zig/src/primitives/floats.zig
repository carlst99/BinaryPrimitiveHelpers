const integers = @import("integers.zig");
const std = @import("std");

/// Reads a 16-bit floating-point number (half) in big endian form.
pub fn readF16BE(source: []const u8) f16 {
    const value: i16 = integers.readI16BE(source);
    return @bitCast(value);
}

/// Reads a 16-bit floating-point number (half) in little endian form.
pub fn readF16LE(source: []const u8) f16 {
    const value: i16 = integers.readI16LE(source);
    return @bitCast(value);
}

/// Reads a 32-bit floating-point number (single) in big endian form.
pub fn readF32BE(source: []const u8) f32 {
    const value: i32 = integers.readI32BE(source);
    return @bitCast(value);
}

/// Reads a 32-bit floating-point number (single) in little endian form.
pub fn readF32LE(source: []const u8) f32 {
    const value: i32 = integers.readI32LE(source);
    return @bitCast(value);
}

/// Reads a 64-bit floating-point number (double) in big endian form.
pub fn readF64BE(source: []const u8) f64 {
    const value: i64 = integers.readI64BE(source);
    return @bitCast(value);
}

/// Reads a 64-bit floating-point number (double) in little endian form.
pub fn readF64LE(source: []const u8) f64 {
    const value: i64 = integers.readI64LE(source);
    return @bitCast(value);
}

/// Reads a 128-bit floating-point number (quad) in big endian form.
pub fn readF128BE(source: []const u8) f128 {
    const value: i128 = integers.readI128BE(source);
    return @bitCast(value);
}

/// Reads a 128-bit floating-point number (quad) in little endian form.
pub fn readF128LE(source: []const u8) f128 {
    const value: i128 = integers.readI128LE(source);
    return @bitCast(value);
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

test readF128BE {
    const data = [_]u8{ 0x3f, 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    try std.testing.expectEqual(1, readF128BE(&data));
}

test readF128LE {
    const data = [_]u8{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xff, 0x3f };
    try std.testing.expectEqual(1, readF128LE(&data));
}
