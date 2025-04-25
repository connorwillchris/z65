const std = @import("std");
const scanner = @import("scanner.zig");

const s =
    \\lda #$00
    \\sta $0100
    \\
;

pub fn main() !void {
    var scan = scanner.Scanner.new(
        std.heap.page_allocator,
        s,
    );
    const toks = try scan.scanTokens();

    for (toks.items) |token| {
        std.debug.print("{s}\n", .{
            token.lexeme,
        });
    }
}
