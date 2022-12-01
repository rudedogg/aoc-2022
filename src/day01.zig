const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

fn sortAscending(context: void, a: u32, b: u32) bool {
    _ = context;
    return a > b;
}

pub fn main() !void {
    var winning_elf_total: u32 = 0;
    var current_elf_total: u32 = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var top_elves_list = std.ArrayList(u32).init(allocator);

    var line_iterator = std.mem.split(u8, data, "\n");

    while (line_iterator.next()) |line| {
        if (std.mem.eql(u8, line, "") == false) {
            const current_value = try std.fmt.parseUnsigned(u32, line, 10);
            current_elf_total = current_elf_total + current_value;
        } else {
            try top_elves_list.append(current_elf_total);

            if (current_elf_total > winning_elf_total) {
                winning_elf_total = current_elf_total;
            }
            current_elf_total = 0;
        }
    }

    std.debug.print("Winning Elf Total: {}\n", .{winning_elf_total});

    std.sort.sort(u32, top_elves_list.items, {}, sortAscending);

    const total = top_elves_list.items[0] + top_elves_list.items[1] + top_elves_list.items[2];
    std.debug.print("Winning Elf Total: {}", .{total});
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
