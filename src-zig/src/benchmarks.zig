const std = @import("std");
const Endian = std.builtin.Endian;
const zbench = @import("zbench");

pub inline fn readInt(comptime T: type, source: []const u8, endian: Endian) T {
    return std.mem.readInt(T, source[0..@divExact(@typeInfo(T).int.bits, 8)], endian);
}
pub fn readIntWithBoundsCheck(comptime T: type, source: []const u8, endian: Endian) !T {
    const type_size = @divExact(@typeInfo(T).int.bits, 8);
    if (type_size > source.len) return error.BufferTooSmall;
    return std.mem.readInt(T, source[0..type_size], endian);
}

fn benchReadInt(allocator: std.mem.Allocator) void {
    _ = allocator;

    const data = [_]u8{ 0x00, 0x01 };
    _ = readInt(u16, &data, .big);
}

fn benchReadIntWithBoundsCheck(allocator: std.mem.Allocator) void {
    _ = allocator;

    const data = [_]u8{ 0x00, 0x01 };
    _ = readIntWithBoundsCheck(u16, &data, .big) catch @panic("buffer too small");
}

fn benchReadIntStd(allocator: std.mem.Allocator) void {
    _ = allocator;

    const data = [_]u8{ 0x00, 0x01 };
    _ = std.mem.readInt(u16, &data, .big);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("benchReadInt", benchReadInt, .{});
    try bench.add("benchReadIntStd", benchReadIntStd, .{});
    try bench.add("benchReadIntWithBoundsCheck", benchReadIntWithBoundsCheck, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
