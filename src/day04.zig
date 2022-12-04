const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

pub fn main() !void {
    var line_iterator = std.mem.split(u8, data, "\n");

    var overlapping_assignments: u32 = 0;

    while (line_iterator.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const ranges = try splitPairsIntoRanges(line);

        if (rangeOverlaps(ranges[0], ranges[1]) or rangeOverlaps(ranges[1], ranges[0])) {
            overlapping_assignments = overlapping_assignments + 1;
        }
    }

    std.debug.print("Overlapping Assignments: {}\n", .{overlapping_assignments});
}

pub const Range = struct {
    lower_bound: u8,
    upper_bound: u8,
};

fn rangeForPair(input: []const u8) !Range {
    const dash_index = std.mem.indexOf(u8, input, "-").?;
    const lower_bound = try std.fmt.parseUnsigned(u8, input[0..dash_index], 10);
    const upper_bound = try std.fmt.parseUnsigned(u8, input[dash_index + 1 ..], 10);
    return Range{ .lower_bound = lower_bound, .upper_bound = upper_bound };
}

fn splitPairsIntoRanges(input: []const u8) ![2]Range {
    const pair_index = std.mem.indexOf(u8, input, ",").?;

    const first_pair_input = input[0..pair_index];
    const first_range = try rangeForPair(first_pair_input);
    const second_pair_input = input[pair_index + 1 ..];
    const second_range = try rangeForPair(second_pair_input);

    return [2]Range{ first_range, second_range };
}

fn rangeOverlaps(lrange: Range, rrange: Range) bool {
    // clamp works too, but seems kind of hacky?
    // return (std.math.clamp(lrange.lower_bound, rrange.lower_bound, rrange.upper_bound) == lrange.lower_bound);
    return (isWithinRange(lrange.lower_bound, rrange) or isWithinRange(lrange.upper_bound, rrange));
}

fn isWithinRange(value: u8, range: Range) bool {
    return (value >= range.lower_bound and value <= range.upper_bound);
}

fn rangeIsSubrange(haystack: Range, needle: Range) bool {
    if (needle.lower_bound >= haystack.lower_bound and needle.upper_bound <= haystack.upper_bound) {
        return true;
    } else {
        return false;
    }
}

test "2-6 rangeForPair" {
    const range = try rangeForPair("2-6");
    try std.testing.expect(range.lower_bound == 2);
    try std.testing.expect(range.upper_bound == 6);
}

test "1-102 rangeForPair" {
    const range = try rangeForPair("1-102");
    try std.testing.expect(range.lower_bound == 1);
    try std.testing.expect(range.upper_bound == 102);
}

test "12-34 rangeForPair" {
    const range = try rangeForPair("12-34");
    try std.testing.expect(range.lower_bound == 12);
    try std.testing.expect(range.upper_bound == 34);
}

test "2-6 is subrange of 2-8" {
    const subrange = try rangeForPair("2-6");
    const range = try rangeForPair("2-8");

    try std.testing.expect(rangeIsSubrange(range, subrange));
}

test "2-2 is subrange of 2-3" {
    const subrange = try rangeForPair("2-2");
    const range = try rangeForPair("2-3");

    try std.testing.expect(rangeIsSubrange(range, subrange));
}

test "5-10 is subrange of 1-11" {
    const subrange = try rangeForPair("5-10");
    const range = try rangeForPair("1-11");

    try std.testing.expect(rangeIsSubrange(range, subrange));
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
