const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

pub fn main() !void {
    const data = @embedFile("data/day08.txt");

    const tree_heights = parseInput(data); // [col], [row] order

    var tree_visibility = std.mem.zeroes([99][99]bool); // [col], [row] order
    tree_visibility = getTreeVisibilities(tree_heights);
    const visible_trees = countVisibleTrees(tree_visibility);

    // std.debug.print("Trees: {c}", .{tree_height[0][1]});
    std.debug.print("Visible Trees: {d}", .{visible_trees});
}

fn countVisibleTrees(tree_visibilities: [99][99]bool) usize {
    var total: usize = 0;

    var col: u8 = 0;
    var row: u8 = 0;
    while (col < 99) : (col += 1) {
        while (row < 99) : (row += 1) {
            if (tree_visibilities[col][row]) {
                total = total + 1;
            }
        }
    }
    return total;
}

fn getTreeVisibilities(tree_heights: [99][99]u8) [99][99]bool {
    var output = std.mem.zeroes([99][99]bool);
    var col: u8 = 0;
    var row: u8 = 0;
    while (col < 99) : (col += 1) {
        while (row < 99) : (row += 1) {
            output[col][row] = determineTreeVisibility(tree_heights, col, row);
        }
    }
    return output;
}
// Check horizontal visibility
fn checkRowVisiblity(tree_heights: [99][99]u8, col: u8, row: u8, our_height: u8) bool {
    if (col == 0 or row == 0 or col == 99 or row == 99) return true;
    var col_to_check: usize = 0;
    // Check left
    var left_visible = true;
    while (col_to_check < col - 1) : (col_to_check += 1) {
        if (our_height <= tree_heights[col_to_check][row]) {
            left_visible = false;
            break;
            // return false;
        }
    }

    // Check bottom
    var right_visible = true;
    col_to_check = col + 1;
    while (col_to_check < 99) : (col_to_check += 1) {
        if (our_height <= tree_heights[col_to_check][row]) {
            right_visible = false;
            break;
            // return false;
        }
    }
    return left_visible or right_visible;
}

// Check vertical visibility
fn checkColVisiblity(tree_heights: [99][99]u8, col: u8, row: u8, our_height: u8) bool {
    if (col == 0 or row == 0 or col == 99 or row == 99) return true;
    var row_to_check: usize = 0;
    // Check top
    var top_visible = true;
    while (row_to_check < row - 1) : (row_to_check += 1) {
        if (our_height <= tree_heights[col][row_to_check]) {
            top_visible = false;
            break;
            // return false;
        }
    }

    // Check bottom
    row_to_check = row + 1;
    var bottom_visible = true;
    while (row_to_check < 99) : (row_to_check += 1) {
        if (our_height <= tree_heights[col][row_to_check]) {
            bottom_visible = false;
            break;
            // return false;
        }
    }
    return top_visible or bottom_visible;
}

fn determineTreeVisibility(tree_heights: [99][99]u8, col: u8, row: u8) bool {
    const our_height = tree_heights[col][row];
    return (checkRowVisiblity(tree_heights, col, row, our_height) or checkColVisiblity(tree_heights, col, row, our_height));
    // while (col_to_check <= 100) : (col_to_check += 1) {
    //     while (row_to_check <= 100) : (row += 1) {
    //         // for (100 - col) |col_to_check| {
    //         //     for (100 - row) |row_to_check| {
    //         if (col_to_check == col and row_to_check == row) {
    //             // Skip ourselves
    //             continue;
    //         }

    //         const test_visibility = tree_heights[col][row];
    //         _ = test_visibility;
    //         if (tree_heights[col_to_check][row_to_check] >= our_height) {
    //             return false;
    //         }
    //     }
    // }
    // return true;
}

/// Returns in [col], [row] order
fn parseInput(input: []const u8) [99][99]u8 {
    var output = std.mem.zeroes([99][99]u8);

    var line_iterator = std.mem.split(u8, input, "\n");
    // var col: u8 = 0;
    var row: u8 = 0;
    while (line_iterator.next()) |line| {
        if (line.len == 0) {
            row = row + 1;
            continue;
        }
        for (line) |char, col| {
            output[col][row] = char;
        }
        row = row + 1;
    }

    // output[11][10] = 5;

    return output;
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
