const std = @import("std");
const Allocator = std.mem.Allocator;
const scanner = @import("scanner.zig");
const Token = scanner.Token;

// a few notes on GRAMMAR:
// z65 uses globals for everything. If it's not defined (before or after), then it's assumed to be global.
// ...otherwise if it's not global, an error will be thrown

// TODO: Identify which directives we have
// DIRECTIVES
// .global IDENTIFIER
// .byte BYTEVALUE - in hex, decimal, or binary (using the % operator)
// .word WORDVALUE - in hex, decimal, or binary (using the % operator)
// .org ADDR - some address in hexadecimal

pub const Parser = struct {
    allocator: Allocator,
    tokens: []Token,
    current_token: Token,

    pub fn new(allocator: Allocator, tokens: []Token) Parser {
        return .{
            .allocator = allocator,
            .tokens = tokens,
        };
    }
};

pub const Node = struct {
    tokens: []Token,
};

// GRAMMAR
// OPCODES = LDA, STA, LDX, STX, ect...
// LABELS = hello_world:, main:, ... -- can only be one label decleration in a single file.
// LITERALS: STRINGS, NUMBERS, and that's about it...
// UNARY EXPRESSION: ! or (-) to perform logical not, and negation, ect...
//
// INSTRUCTION ::= ADC | AND | ASL | BCC | BCS | BEQ | BIT | BMI |
//                 BNE | BPL | BRK | BVC | BVS | CLC | CLD | CLI |
//                 CLV | CMP | CPX | CPY | DEC | DEX | DEY | EOR |
//                 INC | INX | INY | JMP | JSR | LDA | LDX | LDY |
//                 LSR | NOP | ORA | PHA | PHP | PLA | PLP | ROL |
//                 ROR | RTI | RTS | SBC | SEC | SED | SEI | STA |
//                 STX | STY | TAX | TAY | TSX | TXA | TXS | TYA
//
// EXPRESSIONS ::= INSTRUCTION | INSTRUCTION OPERAND
//
// OPERAND     ::= NUMBER16 | NUMBER8 | LABEL

pub const Mode = enum {
    Accumulator,
    Absolute,
    AbsoluteX,
    AbsoluteY,
    Immediate,
    Implied,
    Indirect,
    IndexedX,
    IndexedY,
    Relative,
    Zeropage,
    ZeropageX,
    ZeropageY,
};

pub const OpcodeUniversal = enum(u8) {
    // row 0
    BrkImplied = 0x00,
    OraIndirectX = 0x01,
    OraZeropage = 0x05,
    AslZeropage = 0x06,
    PhpImplied = 0x08,
    OraImmediate = 0x09,
    AslAccumulator = 0x0a,
    OraAbsolute = 0x0d,
    AslAbsolute = 0x0e,

    // row 1
    BplRelative = 0x10,
    OraIndexedY = 0x11,
    OraZeropageX = 0x15,
    AslZeropageX = 0x16,
    ClcImpl = 0x17,
    OraAbsoluteY = 0x19,
    OraAbsoluteX = 0x1d,
    AslAbsoluteX = 0x1e,

    // row 2

};
