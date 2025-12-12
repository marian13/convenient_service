# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  ##
  # Convenient Service gem specification. Used mainly by `convenient_service.gemspec`.
  #
  # @since 1.0.0
  # @see https://guides.rubygems.org/specification-reference
  # @see https://github.com/marian13/convenient_service/blob/main/convenient_service.gemspec
  #
  # @internal
  #   IMPORTNANT: This module must NOT be loaded by the `lib` folder. It is only intended for `gemspec`. `bundle` loads it inside specs.
  #   NOTE: `Specification` module was created to be able to test `gemspec` content.
  #
  module Specification
    ##
    # Convenient Service gem name.
    # It is used by the `gem install convenient_service` command or `gem "convenient_service"` Gemfile directive.
    #
    # @return [String]
    # @since 1.0.0
    #
    NAME = "convenient_service"

    ##
    # Convenient Service gem author names.
    #
    # @return [Array<String>]
    # @since 1.0.0
    #
    AUTHORS = ["Marian Kostyk"].freeze

    ##
    # Convenient Service gem author emails.
    #
    # @return [Array<String>]
    # @since 1.0.0
    #
    EMAIL = ["mariankostyk13895@gmail.com"].freeze

    ##
    # Convenient Service gem homepage URL (GitHub repo URL). It contains references to the user docs, api docs, etc.
    #
    # @return [String]
    # @since 1.0.0
    #
    HOMEPAGE = "https://github.com/marian13/convenient_service"

    ##
    # Convenient Service gem short summary.
    #
    # @return [String]
    # @since 1.0.0
    #
    # @internal
    #   NOTE: Keep summary in sync with the GitHub repo "About" section.
    #
    SUMMARY = <<~TEXT
      Ruby Service Objects with Steps and more.
    TEXT

    ##
    # Convenient Service gem general description.
    #
    # @return [String]
    # @since 1.0.0
    #
    # @internal
    #   NOTE: Keep description in sync with Convenient Service User Docs homepage.
    #
    DESCRIPTION = <<~TEXT
      Manage complex business logic in Ruby applications using Service Objects with Results and Steps.

      Hide technical details with Configs, Concerns and Middlewares.

      Group related code with Features and Entries.
    TEXT
  end
end
