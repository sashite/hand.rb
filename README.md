# hand.rb

[![Version](https://img.shields.io/github/v/tag/sashite/hand.rb?label=Version&logo=github)](https://github.com/sashite/hand.rb/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/hand.rb/main)
[![CI](https://github.com/sashite/hand.rb/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/sashite/hand.rb/actions)
[![License](https://img.shields.io/github/license/sashite/hand.rb)](https://github.com/sashite/hand.rb/blob/main/LICENSE)

> **HAND** (Hold And Notation Designator) implementation for Ruby.

## Overview

This library implements the [HAND Specification v1.0.0](https://sashite.dev/specs/hand/1.0.0/).

## Installation

```ruby
# In your Gemfile
gem "sashite-hand"
```

Or install manually:

```sh
gem install sashite-hand
```

## Usage

### Parsing (String → Symbol)

Convert a HAND string into a symbol.

```ruby
require "sashite/hand"

# Standard parsing (raises on error)
Sashite::Hand.parse("*")  # => :"*"

# Invalid input raises ArgumentError
Sashite::Hand.parse("e4")  # => raises ArgumentError
Sashite::Hand.parse("")    # => raises ArgumentError
```

### Validation

```ruby
# Boolean check
Sashite::Hand.valid?("*")  # => true
Sashite::Hand.valid?("e4") # => false
Sashite::Hand.valid?("")   # => false
```

### Using the Notation Constant

```ruby
# Access the HAND notation symbol
Sashite::Hand::NOTATION # => :"*"

# Convert to string when needed
Sashite::Hand::NOTATION.to_s # => "*"
```

## API Reference

### Constants

```ruby
Sashite::Hand::NOTATION # => :"*"
```

### Parsing

```ruby
# Parses a HAND string into a symbol.
# Raises ArgumentError if the string is not valid.
#
# @param input [String] HAND notation string
# @return [Symbol] the :"*" symbol
# @raise [ArgumentError] if invalid
def Sashite::Hand.parse(input)
```

### Validation

```ruby
# Validates a HAND string.
# Raises ArgumentError with descriptive message if invalid.
#
# @param input [String] HAND notation string
# @return [nil]
# @raise [ArgumentError] if invalid
def Sashite::Hand.validate(input)

# Reports whether string is a valid HAND notation.
#
# @param input [String] HAND notation string
# @return [Boolean]
def Sashite::Hand.valid?(input)
```

### Errors

All parsing and validation errors raise `ArgumentError` with descriptive messages:

| Message | Cause |
|---------|-------|
| `"invalid hand notation"` | Input is not exactly `*` |

```ruby
begin
  Sashite::Hand.parse("**")
rescue ArgumentError => e
  puts e.message # => "invalid hand notation"
end
```

## Design Principles

- **Symbol-based**: Notation represented as Ruby symbol for identity semantics
- **Minimal**: Single constant and three methods
- **Ruby idioms**: `valid?` predicate, `parse` conversion
- **Strict validation**: Only the `*` character is accepted
- **No dependencies**: Pure Ruby standard library only

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [HAND Specification](https://sashite.dev/specs/hand/1.0.0/) — Official specification
- [CELL Specification](https://sashite.dev/specs/cell/1.0.0/) — Complementary notation for Board squares

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
