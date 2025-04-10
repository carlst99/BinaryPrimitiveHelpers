const integers = @import("integers.zig");
const std = @import("std");
const Endian = std.builtin.Endian;

/// Reads a 16-bit floating-point number (half).
pub fn readF16(source: []const u8, endian: Endian) f16 {
    const value: i16 = integers.readI16(source, endian);
    return @bitCast(value);
}

/// Reads a 32-bit floating-point number (single).
pub fn readF32(source: []const u8, endian: Endian) f32 {
    const value: i32 = integers.readI32(source, endian);
    return @bitCast(value);
}

/// Reads a 64-bit floating-point number (double).
pub fn readF64(source: []const u8, endian: Endian) f64 {
    const value: i64 = integers.readI64(source, endian);
    return @bitCast(value);
}

/// Reads a 128-bit floating-point number (quad).
pub fn readF128(source: []const u8, endian: Endian) f128 {
    const value: i128 = integers.readI128(source, endian);
    return @bitCast(value);
}

/// Writes a 16-bit floating-point number (half) in big endian form.
pub fn writeF16BE(dest: []u8, value: u16) void {
    integers.writeI16BE(dest, @bitCast(value));
}

/// Writes a 16-bit floating-point number (half) in little endian form.
pub fn writeF16LE(dest: []u8, value: u16) void {
    integers.writeI16LE(dest, @bitCast(value));
}

test readF16 {
    var data = [_]u8{ 0x3c, 0x00 };
    try std.testing.expectEqual(1, readF16(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readF16(&data, .little));
}

test readF32 {
    var data = [_]u8{ 0x42, 0xAA, 0x40, 0x00 };
    try std.testing.expectEqual(85.125, readF32(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(85.125, readF32(&data, .little));
}

test readF64 {
    var data = [_]u8{ 0x40, 0x55, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00 };
    try std.testing.expectEqual(85.125, readF64(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(85.125, readF64(&data, .little));
}

test readF128 {
    var data = [_]u8{ 0x3f, 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    try std.testing.expectEqual(1, readF128(&data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, readF128(&data, .little));
}

test writeF16BE {
    var data: [2]u8 = undefined;
    writeF16BE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x00, 0x01 }, &data);
}

test writeF16LE {
    var data: [2]u8 = undefined;
    writeF16LE(&data, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 0x01, 0x00 }, &data);
}
