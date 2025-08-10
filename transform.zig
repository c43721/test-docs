const std = @import("std");
const assert = std.debug.assert;
const Template = @import("template.zig").Template;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const args = try std.process.argsAlloc(allocator);
    const file_size_max = 1 << 20; // 1 MiB

    assert(args.len == 1);
    const source_directory = args[0];

    var dir = try std.fs.cwd().openDir(source_directory, .{ .iterate = true });
    defer dir.close();

    var walker = try dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (entry.kind == .file) {
            const content = try std.fs.cwd().readFileAlloc(
                allocator,
                entry.basename,
                file_size_max,
            );

            const template = try Template.write(allocator, content);

            try std.fs.cwd().writeFile(.{ .sub_path = entry.basename, .data = template });
        }
    }
}
