const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

// Start of packet when sequence 4 characters are all different
pub fn main() !void {
    var char_stack = [4]u8{ ' ', ' ', ' ', ' ' };
    var index: usize = 1;
    for (data) |char| {
        std.debug.print("Current char: {c}\n", .{char});

        std.debug.print("Index {d}\n", .{index});

        char_stack[0] = char_stack[1];
        char_stack[1] = char_stack[2];
        char_stack[2] = char_stack[3];
        char_stack[3] = char;

        std.debug.print("Stack {s}\n", .{char_stack});

        if (char_stack[0] != ' ' and
            char_stack[1] != ' ' and
            char_stack[2] != ' ' and
            char_stack[3] != ' ' and
            char_stack[0] != char_stack[1] and
            char_stack[0] != char_stack[2] and
            char_stack[0] != char_stack[3] and
            char_stack[1] != char_stack[0] and
            char_stack[1] != char_stack[2] and
            char_stack[1] != char_stack[3] and
            char_stack[2] != char_stack[0] and
            char_stack[2] != char_stack[1] and
            char_stack[2] != char_stack[3] and
            char_stack[3] != char_stack[0] and
            char_stack[3] != char_stack[1] and
            char_stack[3] != char_stack[2])
        {
            // Match found
            std.debug.print("\nFirst marker: {d}\n", .{index});
            return;
        }
        index = index + 1;
    }
    std.debug.print("\nTop of stacks: \n", .{});
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
