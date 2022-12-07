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
    parent_index: ?usize,
    size: usize,
};

// const Node = struct {
//     parent: ?*Node,
//     name: []const u8,
//     is_dir: bool,
//     size: ?usize,
// };

const Node = struct {
    children: std.ArrayList(Node),
    name: []const u8,
    is_dir: bool,
    size: ?usize,
};

// const FSNode = union {
//     file: ,
//     float: f64,
//     bool: bool,
// };

pub fn main() !void {
    // const tree = std.ArrayList(Directory).init(gpa);
    // _ = tree;

    const root = try parseInput(data);
    _ = root;

    // var line_iterator = std.mem.split(u8, data, "\n");
    // while (line_iterator.next()) |line| {
    //     if (line.len == 0) {
    //         continue;
    //     }
    // }
}

fn parseInput(input: []const u8) !*Node {
    var root = try gpa.create(Node);
    root.* = Node{ .children = List(Node).init(gpa), .name = "", .is_dir = true, .size = null };

    // var cd = try gpa.create(Node);
    var cd: Node = root.*;

    const State = enum { none, dir, ls, cd, file };
    _ = input;
    var state = State.none;
    var line_iterator = std.mem.split(u8, data, "\n");
    while (line_iterator.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var token_iterator = std.mem.tokenize(u8, line, " ,$,\n");

        while (token_iterator.next()) |token| {
            switch (state) {
                .none => {
                    if (std.mem.eql(u8, token, "dir")) {
                        // Next token is the dir name
                        std.debug.print("Directory: {s}\n", .{token});
                        state = .dir;
                    } else if (std.mem.eql(u8, token, "cd")) {
                        // Next token is the dir name
                        std.debug.print("cd: {s}\n", .{token});
                        state = .cd;
                    } else if (std.mem.eql(u8, token, "ls")) {
                        std.debug.print("ls: {s}\n", .{token});
                        state = .ls;
                    } else {
                        // This is a file. Parse the size and name
                        std.debug.print("File name: {s}\n", .{token});
                        // state = .file;
                        const file_size = try std.fmt.parseUnsigned(usize, token, 10);
                        const file_name = token_iterator.next().?;
                        // std.debug.print("File size: {s}\n", .{token});
                        var new_file_node = try gpa.create(Node);
                        new_file_node.* = Node{ .children = List(Node).init(gpa), .name = file_name, .is_dir = false, .size = file_size };
                        continue;
                    }
                },
                .cd => {
                    // token = dir
                    if (std.mem.eql(u8, token, "..")) {
                        // &cd = &cd.parent.?;
                    }
                    std.debug.print("Navigated to: {s}\n", .{token});
                    state = .none;
                },
                .dir => {
                    // token = dir
                    std.debug.print("Found dir named: {s}\n", .{token});
                    // state = .none;
                },
                .ls => {
                    if (std.mem.eql(u8, token, "dir")) {
                        const dir_name = token_iterator.next().?;

                        var new_dir_node = try gpa.create(Node);
                        new_dir_node.* = Node{ .children = List(Node).init(gpa), .name = dir_name, .is_dir = true, .size = null };
                        continue;
                    }
                    std.debug.print("File name: {s}\n", .{token});
                    // state = .file;
                    const file_size = try std.fmt.parseUnsigned(usize, token, 10);
                    const file_name = token_iterator.next().?;
                    // std.debug.print("File size: {s}\n", .{token});
                    // var new_file_node = try gpa.create(Node);
                    // new_file_node.* = Node{ .children = List(Node).init(gpa), .name = file_name, .is_dir = false, .size = file_size };
                    // try cd.children.append(&new_file_node);
                    try cd.children.append(Node{ .children = List(Node).init(gpa), .name = file_name, .is_dir = false, .size = file_size });
                    state = .none;
                    continue;
                    // std.debug.print("Listing out: {s}\n", .{token});
                },
                .file => {
                    // const file_size = try std.fmt.parseUnsigned(usize, token, 10);
                    // const file_name = token_iterator.next().?;
                    // // std.debug.print("File size: {s}\n", .{token});
                    // var new_file_node = try gpa.create(Node);
                    // new_file_node.* = Node{ .parent = &cd, .name = file_name, .is_dir = false, .size = file_size };
                    // state = .;
                },
            }
        }
    }
    return root;
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
