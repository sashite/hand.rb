# frozen_string_literal: true

# Tests for Sashite::Hand (Hold And Notation Designator)
#
# Tests the HAND implementation for Ruby, covering validation
# and canonical representation according to the HAND specification v1.0.0.

require_relative "lib/sashite/hand"

# Helper function to run a test and report errors
def run_test(name)
  print "  #{name}... "
  yield
  puts "✓ Success"
rescue StandardError => e
  warn "✗ Failure: #{e.message}"
  warn "    #{e.backtrace.first}"
  exit(1)
end

puts
puts "Tests for Sashite::Hand (Hold And Notation Designator)"
puts

# Test module-level reserve? method
run_test("Module validation accepts valid reserve notation") do
  raise "* should be valid reserve" unless Sashite::Hand.reserve?("*")
end

run_test("Module validation rejects invalid reserve notations") do
  invalid_notations = ["", "a1", "**", "e4", " *", "* ", "A", "z", "1", "+", "-",
                       "reserve", "hand", "x", "X", "0", "9"]

  invalid_notations.each do |notation|
    raise "#{notation.inspect} should be invalid" if Sashite::Hand.reserve?(notation)
  end
end

run_test("Module validation handles non-string input") do
  non_strings = [nil, 123, :asterisk, [], {}, true, false]

  non_strings.each do |input|
    raise "#{input.inspect} should be invalid" if Sashite::Hand.reserve?(input)
  end
end

run_test("Module to_s returns canonical representation") do
  canonical = Sashite::Hand.to_s

  raise "to_s should return *" unless canonical == "*"
  raise "to_s should return RESERVE constant" unless canonical == Sashite::Hand::RESERVE
end

# Test RESERVE constant
run_test("RESERVE constant is correctly defined") do
  raise "RESERVE should be *" unless Sashite::Hand::RESERVE == "*"
  raise "RESERVE should be frozen" unless Sashite::Hand::RESERVE.frozen?
  raise "RESERVE should be a String" unless Sashite::Hand::RESERVE.is_a?(String)
end

# Test reserve? method with edge cases
run_test("Reserve validation with whitespace") do
  whitespace_cases = [" *", "* ", " * ", "\t*", "*\t", "\n*", "*\n", " \t*\n "]

  whitespace_cases.each do |notation|
    raise "#{notation.inspect} should be invalid (whitespace)" if Sashite::Hand.reserve?(notation)
  end
end

run_test("Reserve validation with similar characters") do
  similar_chars = ["×", "✱", "⋆", "★", "✪", "✯", "※", "＊"]

  similar_chars.each do |char|
    raise "#{char.inspect} should be invalid (not asterisk)" if Sashite::Hand.reserve?(char)
  end
end

run_test("Reserve validation with multiple asterisks") do
  multiple_asterisks = ["**", "***", "****", "*" * 10]

  multiple_asterisks.each do |notation|
    raise "#{notation.inspect} should be invalid (multiple asterisks)" if Sashite::Hand.reserve?(notation)
  end
end

# Test integration scenarios
run_test("Integration with board coordinates") do
  board_positions = ["a1", "e4", "h8", "a1A", "z9Z", "5e", "9i"]
  reserve = "*"

  # Reserve should be different from all board positions
  board_positions.each do |position|
    raise "Reserve should differ from #{position}" if Sashite::Hand.reserve?(position)
  end

  # Only reserve should validate as reserve
  raise "Only * should be reserve" unless Sashite::Hand.reserve?(reserve)
end

run_test("Movement notation examples") do
  # From reserve to board
  source = "*"
  destination = "e4"

  raise "Source should be reserve" unless Sashite::Hand.reserve?(source)
  raise "Destination should not be reserve" if Sashite::Hand.reserve?(destination)

  # From board to reserve (capture)
  captured_position = "e4"
  reserve = "*"

  raise "Captured position should not be reserve" if Sashite::Hand.reserve?(captured_position)
  raise "Reserve should be reserve" unless Sashite::Hand.reserve?(reserve)
end

# Test game-specific scenarios
run_test("Shogi drop notation") do
  reserve = "*"
  board_squares = ["1a", "5e", "9i"]

  raise "Reserve should validate" unless Sashite::Hand.reserve?(reserve)

  board_squares.each do |square|
    raise "#{square} should not be reserve" if Sashite::Hand.reserve?(square)
  end
end

run_test("Crazyhouse drop notation") do
  reserve = "*"
  chess_squares = ["a1", "e4", "h8"]

  raise "Reserve should validate" unless Sashite::Hand.reserve?(reserve)

  chess_squares.each do |square|
    raise "#{square} should not be reserve" if Sashite::Hand.reserve?(square)
  end
end

run_test("Go stone placement notation") do
  reserve = "*"
  go_positions = ["aa", "dd", "ss"]

  raise "Reserve should validate" unless Sashite::Hand.reserve?(reserve)

  go_positions.each do |position|
    raise "#{position} should not be reserve" if Sashite::Hand.reserve?(position)
  end
end

# Test complementary with CELL coordinates
run_test("Complementary with CELL specification") do
  # Simulating CELL-like coordinates validation
  def cell_like?(string)
    return false unless string.is_a?(String)
    string.match?(/\A[a-z]+[0-9]+[A-Z]*\z/)
  end

  def valid_location?(location)
    Sashite::Hand.reserve?(location) || cell_like?(location)
  end

  # Test various locations
  locations = {
    "*"    => true,   # HAND reserve
    "a1"   => true,   # CELL coordinate
    "e4"   => true,   # CELL coordinate
    "a1A"  => true,   # CELL coordinate with layer
    "xx"   => false,  # Invalid
    ""     => false,  # Invalid
    "**"   => false   # Invalid
  }

  locations.each do |location, should_be_valid|
    result = valid_location?(location)
    if should_be_valid
      raise "#{location.inspect} should be valid location" unless result
    else
      raise "#{location.inspect} should be invalid location" if result
    end
  end
end

# Test immutability and thread safety
run_test("Constant immutability") do
  original_reserve = Sashite::Hand::RESERVE

  begin
    Sashite::Hand::RESERVE << "EXTRA"
    raise "Should not be able to modify frozen constant"
  rescue FrozenError
    # Expected behavior
  end

  raise "Constant should remain unchanged" unless Sashite::Hand::RESERVE == original_reserve
end

run_test("Method return value immutability") do
  result = Sashite::Hand.to_s

  raise "Result should be frozen" unless result.frozen?
  raise "Result should equal RESERVE" unless result == Sashite::Hand::RESERVE

  begin
    result << "EXTRA"
    raise "Should not be able to modify returned string"
  rescue FrozenError
    # Expected behavior
  end
end

# Test performance and edge cases
run_test("Empty string handling") do
  raise "Empty string should not be reserve" if Sashite::Hand.reserve?("")
end

run_test("Very long strings") do
  long_string = "*" * 1000

  raise "Long string should not be reserve" if Sashite::Hand.reserve?(long_string)
end

run_test("Unicode asterisk variants") do
  unicode_asterisks = [
    "\u002A",  # Standard asterisk (should work)
    "\u2217",  # Asterisk operator
    "\u204E",  # Low asterisk
    "\u2731",  # Heavy asterisk
    "\uFE61",  # Small asterisk
    "\uFF0A"   # Fullwidth asterisk
  ]

  # Only the standard ASCII asterisk should work
  unicode_asterisks.each_with_index do |char, index|
    if index == 0  # First one is standard asterisk
      raise "Standard asterisk should be valid" unless Sashite::Hand.reserve?(char)
    else
      raise "#{char.inspect} should be invalid (Unicode variant)" if Sashite::Hand.reserve?(char)
    end
  end
end

# Test case sensitivity verification
run_test("Case sensitivity verification") do
  # Though HAND only uses asterisk, verify no case variants exist
  raise "* should be reserve" unless Sashite::Hand.reserve?("*")

  # These don't exist for asterisk, but test principle
  raise "Asterisk has no case variants to test" if "*".downcase != "*" || "*".upcase != "*"
end

# Test specification compliance
run_test("Specification compliance") do
  # Test exact specification requirements from HAND v1.0.0

  # Grammar: <hand> ::= "*"
  raise "Should follow BNF grammar" unless Sashite::Hand.reserve?("*")

  # ASCII compatibility: U+002A
  raise "Should use ASCII asterisk character" unless "*".ord == 42
end

# Test performance with repeated calls
run_test("Performance with repeated calls") do
  # Ensure the implementation is efficient for repeated validation
  1000.times do
    raise "Performance test failed" unless Sashite::Hand.reserve?("*")
    raise "Performance test failed" if Sashite::Hand.reserve?("a1")
  end
end

puts
puts "All HAND tests passed!"
puts
