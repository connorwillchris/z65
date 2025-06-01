const std = @import("std");
const Scanner = @import("scanner.zig").Scanner;

const s =
    \\.global hello_world
    \\hello_world:
    \\    LDA #$00 ; fuck this shit, i'm out!
    \\    sta $0100
    \\    lda #%01010101
    \\    lda #$55
    \\1:  lda #$05
    \\
;

pub fn main() !void {
    var scanner = Scanner.new(
        std.heap.page_allocator,
        s,
    );
    const toks = try scanner.scanTokens();

    for (toks.items) |token| {
        std.debug.print("TokenType: {?}\t\"{s}\"\tLINE: {d}\n", .{
            token.token_type,
            token.lexeme,
            token.line,
        });
    }
}
