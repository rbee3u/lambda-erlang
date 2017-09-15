Definitions.
L = [0-9A-Za-z_]
WS = ([\000-\s]|//.*)

Rules.
{L}+
    : {token, {symbol, TokenLine, TokenChars}}.
\\|\.|\(|\)|=|;
    : {token, {list_to_atom(TokenChars),TokenLine}}.
{WS}+
    : skip_token.

Erlang code.
