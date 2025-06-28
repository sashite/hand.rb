# Hand.rb

[![Version](https://img.shields.io/github/v/tag/sashite/hand.rb?label=Version&logo=github)](https://github.com/sashite/hand.rb/tags)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/hand.rb/main)
![Ruby](https://github.com/sashite/hand.rb/actions/workflows/main.yml/badge.svg?branch=main)
[![License](https://img.shields.io/github/license/sashite/hand.rb?label=License&logo=github)](https://github.com/sashite/hand.rb/raw/main/LICENSE.md)

> **HAND** (Hold And Notation Designator) implementation for the Ruby language.

## What is HAND?

HAND (Hold And Notation Designator) is a standardized notation for representing piece reserve locations in board games where pieces can be held off-board and potentially placed. This applies to games like Shōgi, Crazyhouse, Go, and other games featuring reserve mechanics.

This gem implements the [HAND Specification v1.0.0](https://sashite.dev/specs/hand/1.0.0/), providing a minimalist Ruby interface using a single character: `*` (asterisk).

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

```ruby
require "sashite/hand"

# Check if a location represents the reserve
Sashite::Hand.reserve?("*")    # => true
Sashite::Hand.reserve?("a1")   # => false
Sashite::Hand.reserve?("**")   # => false

# Get the canonical representation
Sashite::Hand.to_s # => "*"
```

### Movement Notation Examples

```ruby
# From reserve to board
source = "*"
destination = "e4"
puts "#{source} → #{destination}" # => "* → e4"

# Shōgi piece drop
puts "Dropping piece from reserve to 5e" if Sashite::Hand.reserve?("*")

# Go stone placement
supply = "*"
puts "Placing stone from supply to dd" if Sashite::Hand.reserve?(supply)
```

## Integration with CELL

HAND complements the [CELL specification](https://sashite.dev/specs/cell/) for complete location coverage:

```ruby
def valid_location?(location)
  Sashite::Cell.valid?(location) || Sashite::Hand.reserve?(location)
end

valid_location?("*")  # => true (reserve)
valid_location?("a1") # => true (board position)
```

## API Reference

### Methods

- `Sashite::Hand.reserve?(location)` - Check if location represents the reserve
- `Sashite::Hand.to_s` - Get the canonical HAND representation (`"*"`)

### Constants

- `Sashite::Hand::RESERVE` - The reserve location character (`"*"`)

## Properties

* **Minimalist**: Single character (`*`) for all reserve operations
* **Universal**: Works across different board game systems
* **Rule-agnostic**: Independent of specific reserve mechanics
* **Complementary**: Designed to work with CELL coordinates

## Protocol Mapping

Following the [Game Protocol](https://sashite.dev/game-protocol/):

| Protocol Attribute | HAND Encoding | Meaning |
|-------------------|---------------|---------|
| **Location** | `*` | Any off-board reserve area |

## Related Specifications

- [CELL](https://sashite.dev/specs/cell/) - Board position coordinates
- [GGN](https://sashite.dev/specs/ggn/) - Movement possibility rules
- [PMN](https://sashite.dev/specs/pmn/) - Portable Move Notation

## Documentation

- [Official HAND Specification v1.0.0](https://sashite.dev/specs/hand/1.0.0/)
- [Game Protocol Foundation](https://sashite.dev/game-protocol/)
- [API Documentation](https://rubydoc.info/github/sashite/hand.rb/main)

## License

Available as open source under the [MIT License](https://opensource.org/licenses/MIT).

## About

Maintained by [Sashité](https://sashite.com/) — promoting chess variants and sharing the beauty of board game cultures.
