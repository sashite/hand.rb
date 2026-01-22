#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../../lib/sashite/hand"

# Helper function to run a test and report errors
def run_test(name)
  print "  #{name}... "
  yield
  puts "✓"
rescue StandardError => e
  warn "✗ Failure: #{e.message}"
  warn "    #{e.backtrace.first}"
  exit(1)
end

puts
puts "=== HAND Tests ==="
puts

# ============================================================================
# CONSTANTS
# ============================================================================

puts "Constants:"

run_test("NOTATION is :\"*\" symbol") do
  raise "should be :\"*\"" unless Sashite::Hand::NOTATION == :"*"
end

run_test("NOTATION is a Symbol") do
  raise "should be a Symbol" unless Sashite::Hand::NOTATION.is_a?(Symbol)
end

run_test("NOTATION.to_s returns \"*\"") do
  raise "should return \"*\"" unless Sashite::Hand::NOTATION.to_s == "*"
end

run_test("ERROR_MESSAGE is defined") do
  raise "should be defined" unless Sashite::Hand::ERROR_MESSAGE == "invalid hand notation"
end

# ============================================================================
# parse
# ============================================================================

puts
puts "parse method:"

run_test("parses \"*\" to :\"*\"") do
  raise "wrong result" unless Sashite::Hand.parse("*") == :"*"
end

run_test("returns NOTATION constant") do
  raise "should be same object" unless Sashite::Hand.parse("*").equal?(Sashite::Hand::NOTATION)
end

run_test("raises ArgumentError for empty string") do
  Sashite::Hand.parse("")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for \"**\"") do
  Sashite::Hand.parse("**")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for CELL coordinate") do
  Sashite::Hand.parse("e4")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for whitespace") do
  Sashite::Hand.parse(" * ")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for leading whitespace") do
  Sashite::Hand.parse(" *")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for trailing whitespace") do
  Sashite::Hand.parse("* ")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for newline") do
  Sashite::Hand.parse("*\n")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

# ============================================================================
# validate
# ============================================================================

puts
puts "validate method:"

run_test("returns nil for \"*\"") do
  raise "should return nil" unless Sashite::Hand.validate("*").nil?
end

run_test("raises ArgumentError for empty string") do
  Sashite::Hand.validate("")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for \"**\"") do
  Sashite::Hand.validate("**")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

run_test("raises ArgumentError for CELL coordinate") do
  Sashite::Hand.validate("a1")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "invalid hand notation"
end

# ============================================================================
# valid?
# ============================================================================

puts
puts "valid? method:"

run_test("returns true for \"*\"") do
  raise "should be valid" unless Sashite::Hand.valid?("*")
end

run_test("returns false for empty string") do
  raise "should be invalid" if Sashite::Hand.valid?("")
end

run_test("returns false for \"**\"") do
  raise "should be invalid" if Sashite::Hand.valid?("**")
end

run_test("returns false for CELL coordinate") do
  raise "should be invalid" if Sashite::Hand.valid?("e4")
end

run_test("returns false for whitespace-padded") do
  raise "should be invalid" if Sashite::Hand.valid?(" * ")
end

run_test("returns false for leading whitespace") do
  raise "should be invalid" if Sashite::Hand.valid?(" *")
end

run_test("returns false for trailing whitespace") do
  raise "should be invalid" if Sashite::Hand.valid?("* ")
end

run_test("returns false for random string") do
  raise "should be invalid" if Sashite::Hand.valid?("hand")
end

# ============================================================================
# SECURITY - NON-STRING INPUT FOR valid?
# ============================================================================

puts
puts "Security - non-string input for valid?:"

run_test("rejects nil") do
  raise "should be invalid" if Sashite::Hand.valid?(nil)
end

run_test("rejects symbol :\"*\"") do
  raise "should be invalid" if Sashite::Hand.valid?(:"*")
end

run_test("rejects integer") do
  raise "should be invalid" if Sashite::Hand.valid?(42)
end

run_test("rejects array") do
  raise "should be invalid" if Sashite::Hand.valid?(["*"])
end

run_test("rejects hash") do
  raise "should be invalid" if Sashite::Hand.valid?({ hand: "*" })
end

run_test("rejects float") do
  raise "should be invalid" if Sashite::Hand.valid?(3.14)
end

# ============================================================================
# SECURITY - MALICIOUS INPUT
# ============================================================================

puts
puts "Security - malicious input:"

run_test("rejects null byte") do
  raise "should be invalid" if Sashite::Hand.valid?("*\x00")
end

run_test("rejects newline") do
  raise "should be invalid" if Sashite::Hand.valid?("*\n")
end

run_test("rejects carriage return") do
  raise "should be invalid" if Sashite::Hand.valid?("*\r")
end

run_test("rejects tab") do
  raise "should be invalid" if Sashite::Hand.valid?("*\t")
end

run_test("rejects unicode lookalike (fullwidth asterisk)") do
  # Fullwidth asterisk U+FF0A
  raise "should be invalid" if Sashite::Hand.valid?("\uFF0A")
end

run_test("rejects zero-width characters") do
  raise "should be invalid" if Sashite::Hand.valid?("*\u200B")
end

# ============================================================================
# ROUND-TRIP TESTS
# ============================================================================

puts
puts "Round-trip tests:"

run_test("parse returns symbol that converts back to valid string") do
  symbol = Sashite::Hand.parse("*")
  string = symbol.to_s
  raise "should still be valid" unless Sashite::Hand.valid?(string)
end

run_test("NOTATION.to_s is valid") do
  raise "should be valid" unless Sashite::Hand.valid?(Sashite::Hand::NOTATION.to_s)
end

run_test("parse of NOTATION.to_s returns NOTATION") do
  result = Sashite::Hand.parse(Sashite::Hand::NOTATION.to_s)
  raise "should be same object" unless result.equal?(Sashite::Hand::NOTATION)
end

puts
puts "All HAND tests passed!"
puts
