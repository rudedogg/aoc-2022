const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

const Choice = enum(u8) { rock = 'A', paper = 'B', scissors = 'C' };
const DesiredOutcome = enum(u8) { lose = 'X', draw = 'Y', win = 'Z' };

pub fn main() !void {
    var total_score: u32 = 0;

    var line_iterator = std.mem.split(u8, data, "\n");

    while (line_iterator.next()) |line| {
        if (std.mem.eql(u8, line, "") == false and std.mem.eql(u8, line, "\n") == false) {
            const desired_outcome = @intToEnum(DesiredOutcome, line[2]);
            const theirs = @intToEnum(Choice, line[0]);
            total_score = total_score + shapePointsForDesiredOutcome(desired_outcome, theirs);
            total_score = total_score + pointsForOutcome(desired_outcome);
        }
    }

    std.debug.print("Total: {}\n", .{total_score});
}

fn pointsForOutcome(desired_outcome: DesiredOutcome) u8 {
    return switch (desired_outcome) {
        .win => 6,
        .draw => 3,
        .lose => 0,
    };
}

fn shapePointsForDesiredOutcome(desired_outcome: DesiredOutcome, theirs: Choice) u8 {
    const rock = 1;
    const paper = 2;
    const scissors = 3;

    return switch (desired_outcome) {
        .win => return switch (theirs) {
            .rock => paper,
            .paper => scissors,
            .scissors => rock,
        },
        .draw => return switch (theirs) {
            .rock => rock,
            .paper => paper,
            .scissors => scissors,
        },
        .lose => return switch (theirs) {
            .rock => scissors,
            .paper => rock,
            .scissors => paper,
        },
    };
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
