# Lambda Calculus in Erlang

This repository is a small experimental project written while learning lambda calculus.

The idea is simple: first build a tiny lambda interpreter, then use plain lambda terms to construct richer behavior step by step, including arithmetic, booleans, data structures, and recursion. The point of the project is the experiment itself, not production-readiness.

## What It Contains

- a lexer built with `leex`
- a parser built with `yecc`
- an `escript` evaluator for beta reduction
- a sample program in [foobar.lambda](foobar.lambda)

The sample program starts from raw lambda calculus and builds:

- Church numerals
- arithmetic operators such as `succ`, `plus`, `mult`, `pow`, `pred`, and `sub`
- booleans and branching
- pair/list-like structures
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

Top-level definitions use `=` and end with `;`:

```text
id = \x.x;
const = \x.\y.x;
id const
```

Single-line comments start with `//`.

## Build

Requirements:

- Erlang/OTP

Installation guide:
[Erlang Installation Guide](http://erlang.org/doc/installation_guide/users_guide.html)

Build the generated scanner and parser modules:

```sh
git clone https://github.com/rbee3u/lambda-erlang.git
cd lambda-erlang
chmod a+x bootstrap lambda
./bootstrap
```

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

- `--help` shows usage
- `--full` prints the fully parenthesized result
- `--step` prints each reduction step

## Example

[foobar.lambda](foobar.lambda) is the main example. It defines arithmetic, booleans, list-like structures, and recursion from pure lambda terms, then evaluates the length of a small encoded list.

A tiny example:

```text
id = \x.x;
id y
```

This project is mainly useful if you want to experiment with how much can be built from a very small lambda calculus core.
