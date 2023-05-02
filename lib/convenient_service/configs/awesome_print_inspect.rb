# frozen_string_literal: true

module ConvenientService
  module Configs
    module AwesomePrintInspect
      include Support::Concern

      # rubocop:disable Lint/ConstantDefinitionInBlock
      included do
        include Configs::Minimal

        ##
        # @internal
        #   TODO: Plugin groups for autoreplacement of plugins with same purpose.
        #
        concerns do
          use Plugins::Service::HasAwesomePrintInspect::Concern
        end

        class self::Result
          concerns do
            use Plugins::Result::HasAwesomePrintInspect::Concern
          end

          class self::Data
            concerns do
              use Plugins::Data::HasAwesomePrintInspect::Concern
            end
          end

          class self::Message
            concerns do
              use Plugins::Message::HasAwesomePrintInspect::Concern
            end
          end

          class self::Code
            concerns do
              use Plugins::Code::HasAwesomePrintInspect::Concern
            end
          end

          class self::Status
            concerns do
              use Plugins::Status::HasAwesomePrintInspect::Concern
            end
          end
        end

        class self::Step
          concerns do
            use Plugins::Step::HasAwesomePrintInspect::Concern
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end
  end
end
