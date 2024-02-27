# frozen_string_literal: true

##
# Convenient Service gem specification.
# @see https://guides.rubygems.org/specification-reference
#
# @internal
#   IMPORTNANT:
#     This module must NOT be loaded by the `lib` folder.
#     It is only intended for `gemspec`.
#     `bundle` loads it inside specs.
#
module ConvenientService
  module Specification
    ##
    # @return [String]
    #
    NAME = "convenient_service"

    ##
    # @return [Array<String>]
    #
    AUTHORS = ["Marian Kostyk"].freeze

    ##
    # @return [Array<String>]
    #
    EMAIL = ["mariankostyk13895@gmail.com"].freeze

    ##
    # @return [String]
    #
    HOMEPAGE = "https://github.com/marian13/convenient_service"

    ##
    # @return [String]
    #
    SUMMARY = <<~TEXT
      Service object pattern implementation in Ruby.
    TEXT

    ##
    # @return [String]
    #
    DESCRIPTION = <<~TEXT
      Yet another approach to revisit the service object pattern in Ruby, but this time focusing on the unique, opinionated, moderately obtrusive, but not mandatory features.
    TEXT
  end
end
