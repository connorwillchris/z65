const std = @import("std");
const scanner = @import("scanner.zig");

const s =
    \\    LDA #$00;fuck
    \\    sta $0100
;

pub fn main() !void {
    var scan = scanner.Scanner.new(
        std.heap.page_allocator,
        s,
    );
    const toks = try scan.scanTokens();

    for (toks.items) |token| {
        std.debug.print("TokenType: {?}\t\"{s}\"\tLINE: {d}\n", .{
            token.token_type,
            token.lexeme,
            token.line,
        });
    }
}
