const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

pub fn main() !void {
    const data = @embedFile("data/day07.txt");
    const part1_total_size = try solvePart1(data);
    std.debug.print("Part 1 Total: {d}\n", .{part1_total_size});
}

fn solvePart1(input: []const u8) !usize {
    const directory_size_map = try parseInput(input);
    const total_map = try accumulateDirectorySizes(directory_size_map);

    const total_size = sumValuesLessThan(total_map, 100_000);
    return total_size;
}

/// Parse the input into a StringHashMap with values of usize (representing total size of file(s) directly in that dir)
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
            std.debug.print("ls Path: {s}\n", .{path.items});
            continue;
        } else if (line[0] >= '0' and line[0] <= '9') {
            var file_iterator = std.mem.split(u8, line, " ");
            const file_size = try std.fmt.parseUnsigned(usize, file_iterator.next().?, 10);
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

    return map;
}

/// Iterate over the paths, adding any child paths totals to their total, and return it as a new StringHashMap(usize)
fn accumulateDirectorySizes(original_map: std.StringHashMap(usize)) !std.StringHashMap(usize) {
    var total_map = std.StringHashMap(usize).init(gpa);
    var original_map_iterator = original_map.iterator();
    while (original_map_iterator.next()) |entry| {
        try total_map.putNoClobber(entry.key_ptr.*, entry.value_ptr.*);

        var nested_map_iterator = original_map.iterator();
        while (nested_map_iterator.next()) |nested_entry| {
            var existing_value = total_map.get(entry.key_ptr.*);
            if (std.mem.startsWith(u8, nested_entry.key_ptr.*, entry.key_ptr.*) and std.mem.eql(u8, nested_entry.key_ptr.*, entry.key_ptr.*) == false) {
                try total_map.put(entry.key_ptr.*, existing_value.? + nested_entry.value_ptr.*);
            }
        }
    }

    return total_map;
}

fn sumValuesLessThan(map: std.StringHashMap(usize), max_size: usize) usize {
    var total: usize = 0;
    var value_iterator = map.valueIterator();
    while (value_iterator.next()) |value| {
        if (value.* < max_size) {
            total = total + value.*;
        }
    }

    return total;
}

test "Sample" {
    const test_data = @embedFile("data/day07test.txt");
    const directory_size_map = try parseInput(test_data);
    const total_map = try accumulateDirectorySizes(directory_size_map);

    const total_size = sumValuesLessThan(total_map, 100_000);

    std.log.warn("total: = {d}\n\n", .{total_size});

    try std.testing.expect(total_size == 95437);
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
