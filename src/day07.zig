const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

const Directory = struct {
    name: []const u8,
    size: usize,
};

pub fn main() !void {
    const file_tree = try parseInput(data);
    _ = file_tree;
}

fn parseInput(input: []const u8) !std.StringHashMap(usize) {
    var path = List(u8).init(gpa);
    var map = std.StringHashMap(usize).init(gpa);

    var line_iterator = std.mem.split(u8, input, "\n");
    while (line_iterator.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        if (std.mem.eql(u8, line[0..4], "$ cd")) {
            if (line.len == 7 and std.mem.eql(u8, line[5..7], "..")) {
                // cd = cd - 1;
                std.debug.print("cd .. on path: {s}", .{path.items});

                if (std.mem.eql(u8, path.items, "/") == false and std.mem.eql(u8, path.items, "") == false) {
                    // _ = path.pop();
                    const last_slash_index = std.mem.lastIndexOf(u8, path.items, "/").?;
                    path.items = path.items[0..last_slash_index];

                    // while (path.pop() != '/') {}
                }
                // path.items =
                // _ = path.pop();
                // const last_slash_index = std.mem.lastIndexOf(u8, path.items, "/").?;
                // path.items = path.items[0..last_slash_index];
                std.debug.print("POP\n", .{});
            } else {
                const dir_name = line[5..];
                if (std.mem.eql(u8, path.items, "/") == false and dir_name[0] != '/') {
                    try path.append('/');
                }
                try path.appendSlice(dir_name);
                // if (std.mem.eql(u8, path.items, "") == false and std.mem.eql(u8, path.items, "/") == false) {
                //     try path.append('/');
                // }
                std.debug.print("Directory Name: {s}\n", .{dir_name});
                std.debug.print("Path: {s}\n", .{path.items});
            }
        } else if (std.mem.eql(u8, line[0..4], "$ ls")) {
            // Should check for queued files and add them here?
            continue;
        } else if (line[0] >= '0' and line[0] <= '9') {
            var file_iterator = std.mem.split(u8, line, " ");
            const file_size = try std.fmt.parseUnsigned(u64, file_iterator.next().?, 10);
            const file_name = file_iterator.next().?;

            var value = map.get(path.items);
            if (value != null) {
                try map.put(try gpa.dupe(u8, path.items), value.? + file_size);
            } else {
                try map.put(try gpa.dupe(u8, path.items), file_size);
            }
            std.debug.print("File Size: {d}\n", .{file_size});
            std.debug.print("File Name: {s}\n", .{file_name});
            // It's a file
        } else {
            // It's a dir name
            continue;
        }
    }
    var total: usize = 0;
    var value_iterator = map.valueIterator();
    while (value_iterator.next()) |value| {
        if (value.* <= 100000) {
            total = total + value.*;
        }
    }
    std.debug.print("total: {d}\n", .{total});
    return map;
    // 1381590 too low
    // 1636474 too high

    //     var token_iterator = std.mem.tokenize(u8, line, " ,$,\n");

    //     while (token_iterator.next()) |token| {
    //         switch (state) {
    //             .none => {
    //                 if (std.mem.eql(u8, token, "dir")) {
    //                     // Next token is the dir name
    //                     std.debug.print("Directory: {s}\n", .{token});
    //                     state = .dir;
    //                 } else if (std.mem.eql(u8, token, "cd")) {
    //                     // Next token is the dir name
    //                     std.debug.print("cd: {s}\n", .{token});
    //                     state = .cd;
    //                 } else if (std.mem.eql(u8, token, "ls")) {
    //                     std.debug.print("ls: {s}\n", .{token});
    //                     state = .ls;
    //                 } else {
    //                     // This is a file. Parse the size and name
    //                     std.debug.print("File name: {s}\n", .{token});
    //                     // state = .file;
    //                     const file_size = try std.fmt.parseUnsigned(usize, token, 10);
    //                     const file_name = token_iterator.next().?;
    //                     // std.debug.print("File size: {s}\n", .{token});
    //                     var new_file_node = try gpa.create(Node);
    //                     new_file_node.* = Node{ .children = List(Node).init(gpa), .name = file_name, .is_dir = false, .size = file_size };
    //                     continue;
    //                 }
    //             },
    //             .cd => {
    //                 // token = dir
    //                 if (std.mem.eql(u8, token, "..")) {
    //                     // &cd = &cd.parent.?;
    //                 }
    //                 std.debug.print("Navigated to: {s}\n", .{token});
    //                 state = .none;
    //             },
    //             .dir => {
    //                 // token = dir
    //                 std.debug.print("Found dir named: {s}\n", .{token});
    //                 // state = .none;
    //             },
    //             .ls => {
    //                 if (std.mem.eql(u8, token, "dir")) {
    //                     const dir_name = token_iterator.next().?;

    //                     var new_dir_node = try gpa.create(Node);
    //                     new_dir_node.* = Node{ .children = List(Node).init(gpa), .name = dir_name, .is_dir = true, .size = null };
    //                     continue;
    //                 }
    //                 std.debug.print("File name: {s}\n", .{token});
    //                 // state = .file;
    //                 const file_size = try std.fmt.parseUnsigned(usize, token, 10);
    //                 const file_name = token_iterator.next().?;
    //                 // std.debug.print("File size: {s}\n", .{token});
    //                 // var new_file_node = try gpa.create(Node);
    //                 // new_file_node.* = Node{ .children = List(Node).init(gpa), .name = file_name, .is_dir = false, .size = file_size };
    //                 // try cd.children.append(&new_file_node);
    //                 try cd.children.append(Node{ .children = List(Node).init(gpa), .name = file_name, .is_dir = false, .size = file_size });
    //                 // state = .none;
    //                 continue;
    //                 // std.debug.print("Listing out: {s}\n", .{token});
    //             },
    //             .file => {
    //                 // const file_size = try std.fmt.parseUnsigned(usize, token, 10);
    //                 // const file_name = token_iterator.next().?;
    //                 // // std.debug.print("File size: {s}\n", .{token});
    //                 // var new_file_node = try gpa.create(Node);
    //                 // new_file_node.* = Node{ .parent = &cd, .name = file_name, .is_dir = false, .size = file_size };
    //                 // state = .;
    //             },
    //         }
    //     }
    // }
    // return root;
}

// fn calculateDirectorySize() void {}

// fn findDirectoriesSmallerThan(max_size: usize) [][]const u8 {
//     _ = max_size;
//     return "";
// }

// fn totalSizeOr(directories: [][]const u8) usize {
//     _ = directories;
// }

test "input 1" {
    std.testing.expect(true);
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
