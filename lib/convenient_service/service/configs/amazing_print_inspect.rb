# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module AmazingPrintInspect
        include Support::Concern

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          ##
          # @internal
          #   TODO: Plugin groups for autoreplacement of plugins with same purpose.
          #
          concerns do
            use ConvenientService::Plugins::Service::HasAmazingPrintInspect::Concern
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Result::HasAmazingPrintInspect::Concern
            end

            class self::Data
              concerns do
                use ConvenientService::Plugins::Data::HasAmazingPrintInspect::Concern
              end
            end

            class self::Message
              concerns do
                use ConvenientService::Plugins::Message::HasAmazingPrintInspect::Concern
              end
            end

            class self::Code
              concerns do
                use ConvenientService::Plugins::Code::HasAmazingPrintInspect::Concern
              end
            end

            class self::Status
              concerns do
                use ConvenientService::Plugins::Status::HasAmazingPrintInspect::Concern
              end
            end
          end

          class self::Step
            concerns do
              use ConvenientService::Plugins::Step::HasAmazingPrintInspect::Concern
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
