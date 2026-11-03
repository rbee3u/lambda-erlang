Nonterminals
Program Def Expr App Atom.

Terminals
symbol '\\' '.' '(' ')' '=' ';'.

%% No conflicts are intended. Unexpected shift/reduce conflicts are warnings,
%% so check bootstrap's diagnostics even when the build succeeds.
Expect 0.

Rootsymbol Program.
Program -> Def ';' Program : ['$1' | '$3'].
Program -> Expr : ['$1'].
Def -> symbol '=' Expr : {def, name('$1'), '$3'}.
%% App excludes bare abstractions so an abstraction's body extends as far
%% right as possible: f \x.x y means f (\x.(x y)).
Expr -> App : '$1'.
Expr -> '\\' symbol '.' Expr : {abs, name('$2'), '$4'}.
Expr -> App '\\' symbol '.' Expr : {app, '$1', {abs, name('$3'), '$5'}}.
App -> App Atom : {app, '$1', '$2'}.
App -> Atom : '$1'.
Atom -> '(' Expr ')' : '$2'.
Atom -> symbol : {var, name('$1')}.

Erlang code.

name({symbol, _, Chars}) -> Chars.
