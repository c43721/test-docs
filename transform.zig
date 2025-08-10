const std = @import("std");
const assert = std.debug.assert;
const Template = @import("template.zig").Template;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const args = try std.process.argsAlloc(allocator);
    const file_size_max = 1 << 20; // 1 MiB

    assert(args.len == 3);

    const source_directory = args[1];
    const destination_directory = args[2];

    var dir = try std.fs.cwd().openDir(source_directory, .{ .iterate = true });
    var output = try std.fs.cwd().openDir(destination_directory, .{});

    defer dir.close();
    defer output.close();

    var walker = try dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (entry.kind == .file) {
            const content = try dir.readFileAlloc(
                allocator,
                entry.path,
                file_size_max,
            );

            const template = try Template.write(allocator, content);

            try output.writeFile(.{ .sub_path = entry.basename, .data = template });
        }
    }
}
