const BphError = @import("../root.zig").BphError;
const std = @import("std");

/// Reads a null-terminated string, returning a slice over the underlying buffer.
pub fn readStringNullTerminated(source: []const u8) BphError![:0]const u8 {
    // Get the index of the first null-terminator (sentinel) past our offset
    const sentinel = [_]u8{0};
    const index = std.mem.indexOf(u8, source, &sentinel);

    // Error out if std.mem.indexOf() could not find the sentinel value
    if (index == null) {
        return BphError.StringNotTerminated;
    }

    // Take a slice between our offsets, and imply the presence of a sentinel
    return source[0..index.? :0];
}

/// Writes a null-terminated string to the `target` buffer.
pub fn writeStringNullTerminated(target: []u8, value: [:0]const u8) BphError!void {
    // Add one to the len, as it does not include the sentinel
    if (value.len + 1 > target.len) return BphError.EndOfStream;
    @memcpy(target[0 .. value.len + 1], value[0 .. value.len + 1]);
}
