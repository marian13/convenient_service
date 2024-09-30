# frozen_string_literal: true

require_relative "stub_entry/constants"
require_relative "stub_entry/entities"

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class StubEntry < Support::Command
          ##
          # @!attribute [r] feature_class
          #   @return [ConvenientService::Feature]
          #
          attr_reader :feature_class

          ##
          # @!attribute [r] entry_name
          #   @return [Symbol, String]
          #
          attr_reader :entry_name

          ##
          # @param feature_class [ConvenientService::Feature]
          # @param entry_name [Symbol, String]
          # @return [void]
          #
          def initialize(feature_class, entry_name)
            @feature_class = feature_class
            @entry_name = entry_name
          end

          ##
          # @return [ConvenientService::RSpec::Helpers::Classes::StubEntry::Entities::StubbedFeature]
          #
          def call
            Entities::StubbedFeature.new(feature_class: feature_class, entry_name: entry_name)
          end
        end
      end
    end
  end
end
