const std = @import("std");
const BphError = @import("../root.zig").BphError;
const Endian = std.builtin.Endian;
const native_endian = @import("builtin").cpu.arch.endian();

/// Reads an integer from the `source` buffer. The length of the `source` buffer must be at least as
/// long as the number of bytes of the integer type (i.e. bit count / 8).
pub fn readInt(comptime T: type, source: []const u8, endian: Endian) BphError!T {
    const type_size = @divExact(@typeInfo(T).int.bits, 8);
    if (type_size > source.len) return BphError.EndOfStream;
    return std.mem.readInt(T, source[0..type_size], endian);
}

/// Reads a floating-point value from the `source` buffer. The length of the `source` buffer
/// must be at least as long as the number of bytes of the float type (i.e. bit count / 8).
pub fn readFloat(comptime T: type, source: []const u8, endian: Endian) BphError!T {
    const int_type: type = @Type(.{
        .int = .{
            .bits = @typeInfo(T).float.bits,
            .signedness = .unsigned,
        },
    });
    const value: int_type = try readInt(int_type, source, endian);
    return @bitCast(value);
}

/// Writes an integer to the `target` buffer. The length of the `target` buffer must be at
/// least as long as the number of bytes of the integer type (i.e. bit count / 8).
pub fn writeInt(comptime T: type, target: []u8, value: T, endian: Endian) BphError!void {
    const type_size = @divExact(@typeInfo(T).int.bits, 8);
    if (type_size > target.len) return BphError.EndOfStream;
    std.mem.writeInt(T, target[0..type_size], value, endian);
}

/// Writes a floating-point value to the `target` buffer. The length of the `target` buffer
/// must be at least as long as the number of bytes of the float type (i.e. bit count / 8).
pub fn writeFloat(comptime T: type, target: []u8, value: T, endian: Endian) BphError!void {
    const int_type: type = @Type(.{
        .int = .{
            .bits = @typeInfo(T).float.bits,
            .signedness = .unsigned,
        },
    });
    const int_value: int_type = @bitCast(value);
    try writeInt(int_type, target, int_value, endian);
}

test readInt {
    try std.testing.expectError(BphError.EndOfStream, readInt(u16, &[_]u8{0x00}, .big));

    // Unsigned
    var data = [_]u8{ 0x00, 0x01 };
    try std.testing.expectEqual(1, try readInt(u16, &data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, try readInt(u16, &data, .little));

    // Signed
    data = [_]u8{ 0xff, 0xfe };
    try std.testing.expectEqual(-2, try readInt(i16, &data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(-2, try readInt(i16, &data, .little));
}

test readFloat {
    var data = [_]u8{ 0x3c, 0x00 };
    try std.testing.expectEqual(1, try readFloat(f16, &data, .big));
    std.mem.reverse(u8, &data);
    try std.testing.expectEqual(1, try readFloat(f16, &data, .little));
}

test writeInt {
    var expected = [_]u8{ 0x00, 0x01 };
    var data: [2]u8 = undefined;

    // Unsigned

    try writeInt(u16, &data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    try writeInt(u16, &data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    // Signed

    expected = [_]u8{ 0xff, 0xfe };

    try writeInt(i16, &data, -2, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    try writeInt(i16, &data, -2, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}

test writeFloat {
    var expected = [_]u8{ 0x3c, 0x00 };
    var data: [2]u8 = undefined;

    try writeFloat(f16, &data, 1, .big);
    try std.testing.expectEqualSlices(u8, &expected, &data);

    std.mem.reverse(u8, &expected);

    try writeFloat(f16, &data, 1, .little);
    try std.testing.expectEqualSlices(u8, &expected, &data);
}
