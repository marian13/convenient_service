# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Commands
          class DefineEntries < Support::Command
            ##
            # @!attribute [r] feature_class
            #   @return [Class]
            #
            attr_reader :feature_class

            ##
            # @!attribute [r] names
            #   @return [Array<String, Symbol>]
            #
            attr_reader :names

            ##
            # @!attribute [r] body
            #   @return [Proc, nil]
            #
            attr_reader :body

            ##
            # @param feature_class [Class]
            # @param names [Array<String, Symbol>]
            # @param body [Proc, nil]
            #
            def initialize(feature_class:, names:, body:)
              @feature_class = feature_class
              @names = names
              @body = body
            end

            ##
            # @return [Array<String, Symbol>]
            #
            def call
              names.map { |name| Commands::DefineEntry.call(feature_class: feature_class, name: name, body: body) }
            end
          end
        end
      end
    end
  end
end
