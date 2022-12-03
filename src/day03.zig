const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    var line_iterator = std.mem.split(u8, data, "\n");

    var sum: usize = 0;
    var newline_count: usize = 1;

    var start_index: usize = 0;
    var end_index: usize = 0;

    while (line_iterator.next()) |line| {
        if (std.mem.eql(u8, line, "") or std.mem.eql(u8, line, "\n")) {
            continue;
        }

        end_index = end_index + line.len + 1;
        newline_count = newline_count + 1;

        if (newline_count % 3 == 1) {
            std.debug.print("\nrucksack_group: \n{s}\n", .{data[start_index..end_index]});
            const common_item = commonItemInRucksacks(data[start_index..end_index]);

            if (common_item != null) {
                sum = sum + priorityOfItem(common_item.?);
            }
            start_index = end_index;
        }
    }

    std.debug.print("Sum: {}\n", .{sum});
}

/// Expected to pass in three lines of rucksacks
fn commonItemInRucksacks(rucksacks: []const u8) ?u8 {
    var line_iterator = std.mem.split(u8, rucksacks, "\n");
    var rucksack1 = line_iterator.next().?;
    var rucksack2 = line_iterator.next().?;
    var rucksack3 = line_iterator.next().?;
    std.debug.print("rucksack1: {s}\n", .{rucksack1});
    std.debug.print("rucksack2: {s}\n", .{rucksack2});
    std.debug.print("rucksack3: {s}\n", .{rucksack3});

    for (rucksack1) |item| {
        const item_shadow = [1]u8{item};
        if (std.mem.indexOf(u8, rucksack2, &item_shadow) != null) {
            if (std.mem.indexOf(u8, rucksack3, &item_shadow) != null) {
                return item;
            }
        }
    }
    return null;
}

fn priorityOfItem(char: u8) u8 {
    if (std.ascii.isLower(char)) {
        // Lowercase item types a through z have priorities 1 through 26.
        // ASCII 'a' = 97, 'a' priority starts at 1 so we offset by -96
        return char - 96;
    } else if (std.ascii.isUpper(char)) {
        // Uppercase item types A through Z have priorities 27 through 52.
        // ASCII 'A' = 65, 'A' priority starts at 27 so we offset by -38
        return char - 38;
    }
    unreachable;
}

test "priority of lowercase letter L" {
    try std.testing.expect(priorityOfItem('L') == 38);
}

test "priority of lowercase letter p" {
    try std.testing.expect(priorityOfItem('p') == 16);
}

test "priority of lowercase letter P" {
    try std.testing.expect(priorityOfItem('P') == 42);
}

test "priority of lowercase letter v" {
    try std.testing.expect(priorityOfItem('v') == 22);
}

test "priority of lowercase letter t" {
    try std.testing.expect(priorityOfItem('t') == 20);
}

test "priority of lowercase letter s" {
    try std.testing.expect(priorityOfItem('s') == 19);
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
