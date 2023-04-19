# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasResultDuckShortSyntax
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @param key [String, Symbol]
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: Delegates to `data` instead of aliasing in order to have an ability
            #   to use the same RSpec stubs for short and usual syntax.
            #
            #   For example:
            #
            #     allow(result).to receive(:data).with(:foo).and_call_original
            #
            #   works for both `result.data[:foo]` and `result[:foo]`.
            #
            def [](key)
              data[key]
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
            #
            def ud
              unsafe_data
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
            #
            def um
              unsafe_message
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
            #
            def uc
              unsafe_code
            end

            ##
            # @return [Boolean]
            #
            def ok?
              success?
            end

            ##
            # @return [Boolean]
            #
            def not_ok?
              not_success?
            end
          end
        end
      end
    end
  end
end
