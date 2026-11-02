Definitions.
SYMBOL_CHAR = [0-9A-Za-z_]
SPACE_OR_COMMENT = ([\000-\s]|//.*)

Rules.
{SYMBOL_CHAR}+
    : {token, {symbol, TokenLine, TokenChars}}.
\\|\.|\(|\)|=|;
    : {token, {list_to_atom(TokenChars), TokenLine}}.
%% Whitespace and `//` comments are skipped by one rule. The wildcard in
%% `//.*` stops only at a newline, so comments may contain any other Unicode
%% character.
{SPACE_OR_COMMENT}+
    : skip_token.

Erlang code.
