const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

pub fn main() !void {
    const allocator = gpa;

    var section_iterator = std.mem.split(u8, data, "\n\n");

    const stacks_input = section_iterator.next().?;
    const moves_input = section_iterator.next().?;

    const stacks = try parseStacks(allocator, stacks_input);
    defer stacks.deinit();
    const moves = try parseMoves(allocator, moves_input);
    defer allocator.free(moves);

    std.debug.print("Total Moves: {}\n", .{moves.len});
    std.debug.print("Total Stacks: {}\n", .{stacks.items.len});
    std.debug.print("Stack 1, Item 7: {c}\n", .{stacks.items[0].items[6]});

    printTopOfStacks(stacks);
    // Part 1
    // _ = try applyMovesToStacks(moves, stacks);
    // Part 2
    try applyOrderedMovesToStacks(allocator, moves, stacks);
    printTopOfStacks(stacks);
}

const Move = struct {
    count: usize,
    source: u8,
    destination: u8,

    fn parse(input: []const u8) !Move {
        var iterator = std.mem.tokenize(u8, input, "move, ,from,to,\n");
        const count = try std.fmt.parseUnsigned(usize, iterator.next().?, 10);
        const source = try std.fmt.parseUnsigned(u8, iterator.next().?, 10);
        const destination = try std.fmt.parseUnsigned(u8, iterator.next().?, 10);

        return Move{ .count = count, .source = source, .destination = destination };
    }
};

fn parseStacks(allocator: Allocator, input: []const u8) !List(List(u8)) {
    var stacks = std.ArrayList(List(u8)).init(allocator);

    var stack_index: u8 = 0;
    while (stack_index < 9) : (stack_index += 1) {
        var stack = std.ArrayList(u8).init(allocator);

        var line_iterator = std.mem.split(u8, input, "\n");
        while (line_iterator.next()) |line| {
            if (line.len == 0 or std.mem.eql(u8, line[0..2], " 1")) {
                continue;
            }

            const char = line[(stack_index * 4) + 1];

            if (char != ' ') {
                try stack.insert(0, char);
            }
        }
        // TODO: Memory management. The nested stack(s) will need freed
        try stacks.append(stack);
    }

    return stacks;
}

fn parseMoves(allocator: Allocator, input: []const u8) ![]Move {
    var moves = std.ArrayList(Move).init(allocator);
    defer moves.deinit();

    var line_iterator = std.mem.split(u8, input, "\n");
    while (line_iterator.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const move = try Move.parse(line);
        try moves.append(move);
    }

    return moves.toOwnedSlice();
}

fn printTopOfStacks(stacks: List(List(u8))) void {
    std.debug.print("Top of stacks: \n", .{});

    for (stacks.items) |stack| {
        std.debug.print(" [{c}] ", .{stack.items[stack.items.len - 1]});
    }

    std.debug.print("\n", .{});
}

fn applyMovesToStacks(moves: []Move, stacks: List(List(u8))) !void {
    for (moves) |move| {
        var count_index: u8 = 0;
        while (count_index < move.count) : (count_index += 1) {
            const item_to_move = stacks.items[move.source - 1].popOrNull();

            if (item_to_move != null) {
                try stacks.items[move.destination - 1].append(item_to_move.?);
            }
        }
    }
}

fn applyOrderedMovesToStacks(allocator: Allocator, moves: []Move, stacks: List(List(u8))) !void {
    for (moves) |move| {
        var move_stack = std.ArrayList(u8).init(allocator);
        defer move_stack.deinit();

        var count_index: u8 = 0;
        while (count_index < move.count) : (count_index += 1) {
            const item_to_move = stacks.items[move.source - 1].popOrNull();
            if (item_to_move != null) {
                try move_stack.insert(0, item_to_move.?);
            }
        }
        // Apply the move
        try stacks.items[move.destination - 1].appendSlice(move_stack.toOwnedSlice());
    }
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
