Nonterminals
Program Def Expr App Atom.

Terminals
symbol '\\' '.' '(' ')' '=' ';'.

%% yecc only warns about unresolved shift/reduce conflicts, resolving them in
%% favor of shift, so an accidental one would still build a parser;
%% unresolved reduce/reduce conflicts are errors. Expect 0 declares that no
%% conflict is intended.
Expect 0.

Rootsymbol Program.
Program -> Def ';' Program : ['$1' | '$3'].
Program -> Expr : ['$1'].
Def -> symbol '=' Expr : {def, name('$1'), '$3'}.
Expr -> App : '$1'.
Expr -> '\\' symbol '.' Expr : {abs, name('$2'), '$4'}.
Expr -> App '\\' symbol '.' Expr : {app, '$1', {abs, name('$3'), '$5'}}.
App -> App Atom : {app, '$1', '$2'}.
App -> Atom : '$1'.
Atom -> '(' Expr ')' : '$2'.
Atom -> symbol : {var, name('$1')}.

Erlang code.

%% yecc hands an action the whole token, so a symbol's name is its third
%% element. Keeping that here means the parser emits finished terms.
name({symbol, _, Chars}) -> Chars.
