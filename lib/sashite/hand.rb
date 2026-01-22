# frozen_string_literal: true

module Sashite
  # HAND (Hold And Notation Designator) implementation.
  #
  # Provides parsing and validation of HAND notation for off-board
  # reserve locations in board games.
  #
  # @example Parsing a notation
  #   Sashite::Hand.parse("*") # => :"*"
  #
  # @example Validation
  #   Sashite::Hand.valid?("*")  # => true
  #   Sashite::Hand.valid?("e4") # => false
  #
  # @see https://sashite.dev/specs/hand/1.0.0/
  module Hand
    # The HAND notation symbol representing an off-board reserve location.
    NOTATION = :"*"

    # Error message for invalid input.
    ERROR_MESSAGE = "invalid hand notation"

    # Parses a HAND string into a symbol.
    #
    # @param input [String] HAND notation string
    # @return [Symbol] the :"*" symbol
    # @raise [ArgumentError] if the string is not valid HAND notation
    #
    # @example
    #   Sashite::Hand.parse("*")   # => :"*"
    #   Sashite::Hand.parse("e4")  # => raises ArgumentError
    def self.parse(input)
      validate(input)
      NOTATION
    end

    # Validates a HAND string.
    #
    # @param input [String] HAND notation string
    # @return [nil]
    # @raise [ArgumentError] if the string is not valid HAND notation
    #
    # @example
    #   Sashite::Hand.validate("*")   # => nil
    #   Sashite::Hand.validate("**")  # => raises ArgumentError
    def self.validate(input)
      raise ::ArgumentError, ERROR_MESSAGE unless valid?(input)
    end

    # Reports whether string is a valid HAND notation.
    #
    # @param input [String] HAND notation string
    # @return [Boolean] true if valid, false otherwise
    #
    # @example
    #   Sashite::Hand.valid?("*")  # => true
    #   Sashite::Hand.valid?("e4") # => false
    def self.valid?(input)
      input == NOTATION.to_s
    end
  end
end
