const std = @import("std");

pub fn searchRight(grid: [][]u8, currRow: u8, currCol: u8, max_cols: u8) bool {
    var found: bool = false;
    if (currCol >= 0 and currCol <= max_cols - 4) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow][currCol + i];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            found = true;
        }
    }
    return found;
}
pub fn searchLeft(grid: [][]u8, currRow: u8, col: u8) bool {
    var found: bool = false;
    if (col >= 3) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow][col - i];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            found = true;
        }
    }
    return found;
}

pub fn searchDown(grid: [][]u8, currRow: u8, currCol: u8, max_rows: usize) bool {
    var found: bool = false;
    if (currRow <= max_rows - 4) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow + i][currCol];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            found = true;
        }
    }
    return found;
}

pub fn searchUp(grid: [][]u8, currRow: u8, currCol: u8) bool {
    var found: bool = false;
    if (currRow >= 3) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow - i][currCol];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            found = true;
        }
    }
    return found;
}

pub fn searchDiagonal(grid: [][]u8, currRow: u8, currCol: u8, max_rows: u8, max_cols: u8) u8 {
    var diagonalCount: u8 = 0;
    // search diagonal down and right
    if (currRow >= 0 and currCol >= 0 and currRow <= max_rows - 4 and currCol <= max_cols - 4) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow + i][currCol + i];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            diagonalCount += 1;
        }
    }
    // search diagonal up and right
    if (currRow >= 3 and currCol >= 0 and currRow < max_rows and currCol <= max_cols - 4) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow - i][currCol + i];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            diagonalCount += 1;
        }
    }
    //search diagonal down and left
    if (currRow >= 0 and currCol >= 3 and currRow <= max_rows - 4 and currCol < max_cols) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow + i][currCol - i];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            diagonalCount += 1;
        }
    }
    // search diagonal up and left
    if (currRow >= 3 and currCol >= 3 and currRow < max_rows and currCol < max_cols) {
        var str: [4]u8 = undefined;
        var i: u8 = 0;
        while (i < 4) : (i += 1) {
            str[i] = grid[currRow - i][currCol - i];
        }
        if (std.mem.eql(u8, &str, "XMAS")) {
            diagonalCount += 1;
        }
    }
    return diagonalCount;
}

pub fn day04part1(currRow: *u8, currCol: *u8, max_cols: *u8, grid: [][]u8) !void {
    var rightXmasCount: u16 = 0;
    var leftXmasCount: u16 = 0;
    var downXmasCount: u16 = 0;
    var upXmasCount: u16 = 0;
    var diagonalCount: u16 = 0;
    while (currRow.* < 140) : (currRow.* += 1) {
        currCol.* = 0;
        while (currCol.* < max_cols.*) : (currCol.* += 1) {
            const rightRes = searchRight(grid, currRow.*, currCol.*, max_cols.*);
            if (rightRes) {
                rightXmasCount += 1;
            }
            const leftRes = searchLeft(grid, currRow.*, currCol.*);
            if (leftRes) {
                leftXmasCount += 1;
            }
            const downRes = searchDown(grid, currRow.*, currCol.*, 140);
            if (downRes) {
                downXmasCount += 1;
            }
            const upRes = searchUp(grid, currRow.*, currCol.*);
            if (upRes) {
                upXmasCount += 1;
            }
            diagonalCount += searchDiagonal(grid, currRow.*, currCol.*, 140, @as(u8, max_cols.*));
        }
    }
    const total: u16 = rightXmasCount + leftXmasCount + downXmasCount + upXmasCount + diagonalCount;
    std.debug.print("total: {d}\n", .{total});
}

pub fn day04part2(currRow: *u8, currCol: *u8, max_cols: *u8, grid: [][]u8) !void {
    var xmasCount: u16 = 0;
    while (currRow.* < 140) : (currRow.* += 1) {
        currCol.* = 0;
        while (currCol.* < max_cols.*) : (currCol.* += 1) {
            if (currRow.* >= 1 and currCol.* >= 1 and currRow.* <= max_cols.* - 2 and currCol.* <= max_cols.* - 2) {
                var str: [3]u8 = undefined;
                var i: u8 = 0;
                // diagonal right down
                while (i < 3) : (i += 1) {
                    str[i] = grid[currRow.* - 1 + i][currCol.* - 1 + i];
                }
                if (std.mem.eql(u8, &str, "MAS") or std.mem.eql(u8, &str, "SAM")) {
                    i = 0;
                    // diagonal left down
                    while (i < 3) : (i += 1) {
                        str[i] = grid[currRow.* - 1 + i][currCol.* + 1 - i];
                    }
                    if (std.mem.eql(u8, &str, "MAS") or std.mem.eql(u8, &str, "SAM")) {
                        xmasCount += 1;
                    }
                }
            }
        }
    }
    std.debug.print("total: {d}\n", .{xmasCount});
}

pub fn main() !void {
    // Get allocator for reading file
    // The .{} is an empty struct literal in Zig, representing default configuration options for the allocator
    // The second {} initializes the allocator instance itself
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read file contents
    const maxBytes = @as(u32, 1) << 18;
    std.debug.print("maxBytes: {}\n", .{maxBytes});
    const file_contents = try std.fs.cwd().readFileAlloc(allocator, "src/2024/day-04/input.txt", maxBytes);
    defer allocator.free(file_contents);

    var max_cols: u8 = 0;
    var current_cols: u8 = 0;
    var rows: u8 = 0;

    for (file_contents) |char| {
        if (char == '\n') {
            rows += 1;
            // Keep track of the longest row
            max_cols = @max(max_cols, current_cols);
            current_cols = 0;
        } else {
            current_cols += 1;
        }
    }

    // Account for last row if it doesn't end with newline
    if (current_cols > 0) {
        rows += 1;
        max_cols = @max(max_cols, current_cols);
    }

    std.debug.print("max_cols: {d}\n", .{max_cols});
    std.debug.print("rows: {d}\n", .{rows});

    // Create dynamic 2D array
    var grid = try allocator.alloc([]u8, rows); // Creates: [_, _, ..., nth row]
    // defer allocator.free(grid);
    defer {
        for (grid) |row| {
            allocator.free(row);
        }
        allocator.free(grid);
    }

    for (grid) |*row| {
        row.* = try allocator.alloc(u8, max_cols);
    }

    var currRow: u8 = 0;
    var currCol: u8 = 0;
    for (file_contents) |char| {
        if (char == '\n') {
            currRow += 1;
            currCol = 0;
        } else {
            grid[currRow][currCol] = char;
            currCol += 1;
        }
    }

    currRow = 0;
    // day04part1(&currRow, &currCol, &max_cols, grid) catch |err| {
    //     std.debug.print("Error: {s}\n", .{@errorName(err)});
    //     return;
    // };
    day04part2(&currRow, &currCol, &max_cols, grid) catch |err| {
        std.debug.print("Error: {s}\n", .{@errorName(err)});
        return;
    };
}
