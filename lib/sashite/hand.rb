# frozen_string_literal: true

module Sashite
  # HAND (Hold And Notation Designator) implementation
  #
  # HAND defines a simple, standardized notation for piece reserve locations
  # in board games where pieces can be held off-board and potentially placed.
  #
  # @see https://sashite.dev/specs/hand/1.0.0/
  # @author Sashité
  #
  # @example Basic usage
  #   Sashite::Hand.reserve?("*")     # => true
  #   Sashite::Hand.reserve?("a1")    # => false
  #   Sashite::Hand.to_s              # => "*"
  module Hand
    # The reserve location character
    RESERVE = "*"

    # Check if a string represents the reserve location
    #
    # @param string [String] the string to check
    # @return [Boolean] true if the string is the reserve location
    #
    # @example
    #   Sashite::Hand.reserve?("*")   # => true
    #   Sashite::Hand.reserve?("a1")  # => false
    #   Sashite::Hand.reserve?("**")  # => false
    #   Sashite::Hand.reserve?("")    # => false
    def self.reserve?(string)
      RESERVE.eql?(string)
    end

    # Get the canonical HAND representation
    #
    # @return [String] the reserve location character
    #
    # @example
    #   Sashite::Hand.to_s            # => "*"
    def self.to_s
      RESERVE
    end
  end
end
