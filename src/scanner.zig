const std = @import("std");

pub const Scanner = struct {
    allocator: std.mem.Allocator,
    source: []const u8,
    tokens: std.ArrayList(Token),
    start: usize = 0,
    current: usize = 0,
    line: usize = 1,

    pub fn new(
        allocator: std.mem.Allocator,
        source: []const u8,
    ) Scanner {
        return .{
            .allocator = allocator,
            .source = source,
            .tokens = std.ArrayList(Token).init(allocator),
        };
    }

    pub fn scanTokens(self: *Scanner) !std.ArrayList(Token) {
        while (!self.isAtEnd()) {
            self.start = self.current;
            try self.scanToken();
        }

        try self.tokens.append(Token.new(
            TokenType.EndOfFile,
            "",
            self.line,
        ));
        return self.tokens;
    }

    fn isAtEnd(self: *Scanner) bool {
        return self.current >= self.source.len;
    }

    fn scanToken(self: *Scanner) !void {
        const c = self.advance();
        switch (c) {
            '(' => try self.addToken(
                TokenType.LeftParen,
                //undefined,
            ),
            ')' => try self.addToken(
                TokenType.RightParen,
                //undefined,
            ),
            ',' => try self.addToken(
                TokenType.Comma,
                //undefined,
            ),
            '.' => try self.addToken(
                TokenType.Period,
                //undefined,
            ),
            '-' => try self.addToken(
                TokenType.Minus,
                //undefined,
            ),
            '/' => try self.addToken(
                TokenType.Slash,
                //undefined,
            ),
            '*' => try self.addToken(
                TokenType.Star,
                //undefined,
            ),
            '!' => try self.addToken(
                TokenType.Bang,
                //undefined,
            ),
            '=' => try self.addToken(
                TokenType.Equal,
                //undefined,
            ),
            '<' => try self.addToken(
                TokenType.Greater, //undefined),
            ),
            '>' => try self.addToken(
                TokenType.Less, //undefined),
            ),
            '#' => try self.addToken(
                TokenType.Hash, //undefined
            ),
            '$' => try self.addToken(
                TokenType.DollarSign, //undefined
            ),
            '%' => try self.addToken(TokenType.Percent),
            ':' => try self.addToken(TokenType.Colon),

            // comments
            ';' => {
                while (self.peek() != '\n' and !self.isAtEnd()) {
                    _ = self.advance();
                }
            },
            ' ', '\r', '\t' => {
                //std.debug.print("Found whitespace at: {d}:{d}\n", .{ self.line, self.current });
            },
            '\n' => self.line += 1,
            // strings
            '\"' => {
                try self.isString();
            },

            else => {
                if (self.isDigit(c)) {
                    try self.isNumber();
                } else if (self.isAlpha(c)) {
                    try self.isIdentifier();
                } else {
                    std.debug.print("Unexpected character.\n", .{});
                }
            },
        }
    }

    fn peek(self: *Scanner) u8 {
        if (self.isAtEnd()) return 0 else return self.source[self.current];
    }

    fn peekNext(self: *Scanner) u8 {
        if (self.current + 1 >= self.source.len) return 0 else return self.source[self.current + 1];
    }

    fn addToken(
        self: *Scanner,
        token_type: TokenType,
        //literal: *const anyopaque,
    ) !void {
        try self.tokens.append(Token.new(
            token_type,
            self.source[self.start..self.current],
            //literal,
            self.line,
        ));
    }

    fn advance(self: *Scanner) u8 {
        self.current +%= 1;
        return self.source[self.current - 1];
    }

    fn match(
        self: *Scanner,
        expected: u8,
    ) bool {
        if (self.isAtEnd()) return false;
        if (self.source[self.current] != expected) return false;

        self.current += 1;
        return true;
    }

    fn isString(self: *Scanner) !void {
        while (self.peek() != '\"' and !self.isAtEnd()) {
            if (self.peek() == '\n') self.line += 1;

            _ = self.advance();
        }

        if (self.isAtEnd()) {
            std.debug.print("Unterminated string on line: {d}\n", .{self.line});
            return;
        }

        _ = self.advance();

        //const value = self.source[(self.start + 1)..(self.current - 1)];
        try self.addToken(
            TokenType.String,
            //@ptrCast(value),
        );
    }

    fn isNumber(self: *Scanner) !void {
        while (self.isDigit(self.peek())) _ = self.advance();
        //const value = try std.fmt.parseInt(
        //u32,
        //self.source[self.start..self.current],
        // 10,
        //);

        try self.addToken(
            TokenType.Number,
            //&value,
        );
    }

    fn isDigit(_: *Scanner, c: u8) bool {
        return c >= '0' and c <= '9';
    }

    fn isAlpha(_: *Scanner, c: u8) bool {
        return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_';
    }

    fn isAlphaNumeric(self: *Scanner, c: u8) bool {
        return self.isAlpha(c) or self.isDigit(c);
    }

    fn isIdentifier(self: *Scanner) !void {
        while (self.isAlphaNumeric(self.peek())) _ = self.advance();
        const text: []const u8 = self.source[self.start..self.current];

        // do all the other tokens here.
        var token_type: TokenType = undefined;
        const buf = try std.ascii.allocLowerString(
            self.allocator,
            text,
        );
        defer self.allocator.free(buf);

        if (std.mem.eql(u8, buf, "lda")) {
            token_type = TokenType.LDA;
        } else if (std.mem.eql(u8, buf, "sta")) {
            token_type = TokenType.STA;
        } else {
            token_type = TokenType.None;
        }

        if (token_type == TokenType.None) token_type = TokenType.Identifier;
        try self.addToken(
            token_type,
            //undefined,
        );
    }
};

pub const Token = struct {
    token_type: TokenType,
    lexeme: []const u8,
    //literal: *const anyopaque,
    line: usize,

    pub fn new(
        token_type: TokenType,
        lexeme: []const u8,
        //literal: *const anyopaque,
        line: usize,
    ) Token {
        return .{
            .token_type = token_type,
            .lexeme = lexeme,
            //.literal = literal,
            .line = line,
        };
    }
};

pub const TokenType = enum {
    // one or two character tokens
    LeftParen,
    RightParen,
    Comma,
    Period,
    Minus,
    Semicolon,
    Colon,
    Slash,
    Star,
    Bang,
    Equal,
    Greater,
    Less,
    Hash,
    DollarSign,
    Percent,

    // literals
    Identifier,
    String,
    Number,

    // keywords, or opcodes
    ADC,
    AND,
    ASL,
    BCC,
    BCS,
    BEQ,
    BIT,
    BMI,
    BNE,
    BPL,
    BRK,
    BVC,
    BVS,
    CLC,
    CLD,
    CLI,
    CLV,
    CMP,
    CPX,
    CPY,
    DEC,
    DEX,
    DEY,
    EOR,
    INC,
    INX,
    INY,
    JMP,
    JSR,
    LDA,
    LDX,
    LDY,
    LSR,
    NOP,
    ORA,
    PHA,
    PHP,
    PLA,
    PLP,
    ROL,
    ROR,
    RTI,
    RTS,
    SBC,
    SEC,
    SED,
    SEI,
    STA,
    STX,
    STY,
    TAX,
    TAY,
    TSX,
    TXA,
    TXS,
    TYA,

    EndOfFile,
    None,
};
