# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "sashite-hand"
  spec.version                = ::File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "HAND (Hold And Notation Designator) implementation for Ruby"
  spec.description            = "Hold And Notation Designator (HAND) provides a standardized notation for piece reserve locations in board games where pieces can be held off-board and potentially placed. Implements HAND Specification v1.0.0."
  spec.homepage               = "https://github.com/sashite/hand.rb"
  spec.license                = "Apache-2.0"
  spec.files                  = ::Dir["LICENSE", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.2.0"

  spec.metadata = {
    "bug_tracker_uri"       => "https://github.com/sashite/hand.rb/issues",
    "documentation_uri"     => "https://rubydoc.info/github/sashite/hand.rb/main",
    "homepage_uri"          => "https://github.com/sashite/hand.rb",
    "source_code_uri"       => "https://github.com/sashite/hand.rb",
    "specification_uri"     => "https://sashite.dev/specs/hand/1.0.0/",
    "rubygems_mfa_required" => "true"
  }
end
