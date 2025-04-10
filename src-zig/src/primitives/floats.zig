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

/// Writes a 16-bit floating-point number (half).
pub fn writeF16(dest: []u8, value: f16, endian: Endian) void {
    integers.writeI16(dest, @bitCast(value), endian);
}

/// Writes a 32-bit floating-point number (single).
pub fn writeF32(dest: []u8, value: f32, endian: Endian) void {
    integers.writeI32(dest, @bitCast(value), endian);
}

/// Writes a 64-bit floating-point number (double).
pub fn writeF64(dest: []u8, value: f64, endian: Endian) void {
    integers.writeI64(dest, @bitCast(value), endian);
}

/// Writes a 128-bit floating-point number (quad).
pub fn writeF128(dest: []u8, value: f128, endian: Endian) void {
    integers.writeI128(dest, @bitCast(value), endian);
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

test writeF16 {
    var expected = [_]u8{ 0x3c, 0x00 };
    var data: [2]u8 = undefined;

    writeF16(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeF16(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeF32 {
    var expected = [_]u8{ 0x42, 0xAA, 0x40, 0x00 };
    var data: [4]u8 = undefined;

    writeF32(&data, 85.125, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeF32(&data, 85.125, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeF64 {
    var expected = [_]u8{ 0x40, 0x55, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00 };
    var data: [8]u8 = undefined;

    writeF64(&data, 85.125, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeF64(&data, 85.125, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeF128 {
    var expected = [_]u8{ 0x3f, 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    var data: [16]u8 = undefined;

    writeF128(&data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    writeF128(&data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}
