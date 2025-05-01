const std = @import("std");
const scanner = @import("scanner.zig");

const s =
    \\.global hello_world
    \\hello_world:
    \\    LDA #$00 ;fuck this shit, i'm out!
    \\    sta $0100
    \\    lda #%01010101
    \\    lda #$55
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
