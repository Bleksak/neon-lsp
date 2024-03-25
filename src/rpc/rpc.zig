const std = @import("std");

pub fn EncodeMessage(msg: anytype) ![]u8 {
    var string = std.ArrayList(u8).init(std.heap.page_allocator);
    defer string.deinit();

    try std.json.stringify(msg, .{}, string.writer());

    return try std.fmt.allocPrint(std.heap.page_allocator, "Content-Length: {d}\r\n\r\n{s}", .{ string.items.len, string.items });
}

test "EncodeMessage" {
    const expected = "Content-Length: 16\r\n\r\n{\"testing\":true}";
    const actual = try EncodeMessage(.{ .testing = true });

    try std.testing.expect(std.mem.eql(u8, expected, actual));
}
