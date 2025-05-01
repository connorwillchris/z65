const std = @import("std");
const scanner = @import("scanner.zig");

// a few notes on GRAMMAR:
// z65 uses globals for everything. If it's not defined (before or after), then it's assumed to be global.
// ...otherwise if it's not global, an error will be thrown

// DIRECTIVES
// TODO:
// .global IDENTIFIER
// .byte BYTEVALUE - in hex, decimal, or binary (using the % operator)
// .word WORDVALUE - in hex, decimal, or binary (using the % operator)

pub const Parser = struct {
    tokens: []scanner.Token,

    pub fn new(tokens: []scanner.Token) Parser {
        return .{ .tokens = tokens };
    }
};

pub const Node = struct {
    token: scanner.Token,
};

// GRAMMAR
// OPCODES = LDA, STA, LDX, STX, ect...
// LABELS = hello_world:, main:, ... -- can only be one label decleration in a single file.
// LITERALS: STRINGS, NUMBERS, and that's about it...
// UNARY EXPRESSION: ! or (-) to perform logical not, and negation, ect...
//
// OPCODES ::= ADC | AND | ASL | BCC | BCS | BEQ | BIT | BMI |
//             BNE | BPL | BRK | BVC | BVS | CLC | CLD | CLI |
//             CLV | CMP | CPX | CPY | DEC | DEX | DEY | EOR |
//             INC | INX | INY | JMP | JSR | LDA | LDX | LDY |
//             LSR | NOP | ORA | PHA | PHP | PLA | PLP | ROL |
//             ROR | RTI | RTS | SBC | SEC | SED | SEI | STA |
//             STX | STY | TAX | TAY | TSX | TXA | TXS | TYA
//
// EXPRESSIONS ::= OPCODE | OPCODE GROUP
//
// GROUP ::=
