# Lambda Calculus in Erlang

This repository is a small experimental project written while learning lambda calculus.

The idea is simple: first build a tiny lambda interpreter, then use plain lambda terms to construct richer behavior step by step, including arithmetic, booleans, data structures, and recursion. The point of the project is the experiment itself, not production-readiness.

## What It Contains

- a lexer built with `leex`
- a parser built with `yecc`
- an `escript` evaluator that performs normal-order beta reduction to normal form, with capture-avoiding substitution
- a sample program in [foobar.lambda](foobar.lambda)

The sample program starts from raw lambda calculus and builds:

- Church numerals
- arithmetic operators such as `succ`, `plus`, `mult`, `pow`, `pred`, and `sub`
- booleans and branching
- pairs and list-like structures
- recursion with the `Y` combinator

## Language

The syntax is intentionally minimal.

### Core Forms

Variables:

```text
x
foo
bar_1
```

A symbol is any non-empty sequence of ASCII letters, digits, and underscores, so `0` is a name just like `bar_1`; the language has no numeric literals. Source files must be UTF-8 (without a BOM), and only comments may contain non-ASCII characters.

Abstractions:

```text
\x.x
\x.\y.x
```

Applications are left-associative:

```text
f x y
```

which means:

```text
((f x) y)
```

Parentheses can be used to control grouping:

```text
(\x.x) y
```

An abstraction can be an application argument without parentheses, but its body extends as far right as possible: `f \x.x y` means `f (\x.(x y))`.

Top-level definitions use `=` and end with `;`. A program is zero or more definitions followed by one final expression, and the program's result is the normal form of that expression:

```text
id = \x.x;
const = \x.\y.x;
id const
```

The final expression takes no trailing `;`, and a file that only defines names is an error.

Definitions are sequential and non-recursive. Each definition is in scope for later definitions and the final expression, but not for its own body. Redefining a name shadows its earlier definition only in the expressions that follow; it does not change earlier definition bodies.

Unbound names remain free rather than causing an error. A later definition does not bind an earlier occurrence of its name:

```text
x = y;
y = z;
x
```

This evaluates to the free variable `y`. Definitions become nested abstractions and applications, which `--step` shows in step 0.

Line comments start with `//` and run to the end of the line.

## Build

Requirements:

- Erlang/OTP with `escript`, the compiler, and `parsetools` (`leex` and `yecc`)

Installation guide:
[Erlang Installation Guide](https://www.erlang.org/doc/system/installation_guide.html)

Build the generated scanner and parser modules:

```sh
git clone https://github.com/rbee3u/lambda-erlang.git
cd lambda-erlang
chmod a+x bootstrap lambda
./bootstrap
```

The generated `.erl` modules and their `.beam` files are ignored by git; re-run `./bootstrap` from the repository root after editing `lambda_scanner.xrl` or `lambda_parse.yrl`. The evaluator reports an error if a module is missing or its grammar source is newer than its `.beam` file.

## Usage

Run a lambda source file:

```sh
./lambda foobar.lambda
```

Command line:

```text
usage: lambda [--help] [--full] [--step] <file>
```

Options:

- `--help` shows usage; no source file is required
- `--full` uses fully parenthesized output instead of the abbreviated form
- `--step` prints the initial term as step 0 and every subsequent beta-reduction step, including the final normal form, which is then repeated after `Result:`

Printed terms are themselves valid source. To evaluate a result again, save only the expression following `Result:` to a source file; the `Result:` and `Step N:` headers are not valid source.

On error, a message is written to standard error and the process exits with status 1.

Reduction continues inside abstraction bodies and skips unused arguments. For example, `(\x.y) ((\x.x x) (\x.x x))` evaluates to `y` even though its argument has no normal form.

Terms without a normal form do not terminate; interrupt the run with `Ctrl+C`. There is no reduction-step limit. A diverging term may repeat unchanged, as `(\x.x x) (\x.x x)` does, or grow and consume increasing memory.

## Example

[foobar.lambda](foobar.lambda) is the main example. It defines arithmetic, booleans, list-like structures, and recursion from pure lambda terms, then evaluates the length of a small encoded list. Running it prints:

```text
Result:
\f.\x.f (f (f (f x)))
```

That result is the Church numeral 4, the length of the encoded list.

To trace a smaller program, save this as `identity.lambda`:

```text
id = \x.x;
id y
```

Run it with `--step`:

```sh
./lambda --step identity.lambda
```

```text
Step 0:
(\id.id y) \x.x
Step 1:
(\x.x) y
Step 2:
y
Result:
y
```

Step 0 shows the definition converted to an abstraction and application. The
result is `y`: the name is never bound, so it stays free.

To avoid capture, the evaluator renames a binder when needed, so a result may use a name that was not in the source; for example, `(\x.\y.x) y` prints `\a.y`.

This project is mainly useful if you want to experiment with how much can be built from a very small lambda calculus core.
