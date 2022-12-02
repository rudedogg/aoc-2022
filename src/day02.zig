const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

const TheirShape = enum(u8) { rock = 'A', paper = 'B', scissors = 'C' };
const OurShape = enum(u8) { rock = 'X', paper = 'Y', scissors = 'Z' };

fn pointsForOurShape(our_shape: OurShape) u8 {
    return switch (our_shape) {
        .rock => 1,
        .paper => 2,
        .scissors => 3,
    };
}

fn scoreOfGame(ours: OurShape, theirs: TheirShape) u8 {
    const loss = 0;
    const draw = 3;
    const win = 6;

    return switch (ours) {
        .rock => return switch (theirs) {
            .rock => draw,
            .paper => loss,
            .scissors => win,
        },
        .paper => return switch (theirs) {
            .rock => win,
            .paper => draw,
            .scissors => loss,
        },
        .scissors => return switch (theirs) {
            .rock => loss,
            .paper => win,
            .scissors => draw,
        },
    };
}

pub fn main() !void {

    // Score for win/loss
    // 0 = loss
    // 3 = draw
    // 6 = win

    // Shape values
    // 1 = rock
    // 2 = paper
    // 3 = scissors

    var total_score: u32 = 0;

    var line_iterator = std.mem.split(u8, data, "\n");

    while (line_iterator.next()) |line| {
        if (std.mem.eql(u8, line, "") == false and std.mem.eql(u8, line, "\n") == false) {
            const ours = @intToEnum(OurShape, line[2]);
            const theirs = @intToEnum(TheirShape, line[0]);
            total_score = total_score + scoreOfGame(ours, theirs);
            total_score = total_score + pointsForOurShape(ours);
        }
    }

    std.debug.print("Total: {}\n", .{total_score});
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
