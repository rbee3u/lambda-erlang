Nonterminals
Root Attr Main Expr Seqs Atom.

Terminals
symbol '\\' '.' '(' ')' '=' ';'.

Expect 0.

Rootsymbol Root.
Root -> Attr ';' Root : ['$1' | '$3'].
Root -> Main : ['$1'].
Attr -> symbol '=' Expr : {def, '$1', '$3'}.
Main -> Expr : '$1'.
Expr -> Seqs : '$1'.
Expr -> '\\' symbol '.' Expr : {abs, '$2', '$4'}.
Seqs -> Seqs '\\' symbol '.' Expr
                : {app, '$1', {abs, '$3', '$5'}}.
Seqs -> Seqs Atom : {app, '$1', '$2'}.
Seqs -> Atom : '$1'.
Atom -> '(' Expr ')': '$2'.
Atom -> symbol : {var, '$1'}.

Erlang code.
