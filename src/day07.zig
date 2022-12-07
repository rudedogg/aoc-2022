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
                std.debug.print("cd .. on path: {s}", .{path.items});

                if (std.mem.eql(u8, path.items, "/") == false) {
                    while (path.pop() != '/') {}
                }
            } else {
                const dir_name = line[5..];
                if (std.mem.eql(u8, path.items, "/") == false and dir_name[0] != '/') {
                    try path.append('/');
                }
                try path.appendSlice(dir_name);
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
}

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
