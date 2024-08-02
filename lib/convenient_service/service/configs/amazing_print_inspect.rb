# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module AmazingPrintInspect
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include ConvenientService::Core

          ##
          # @internal
          #   TODO: Plugin groups for autoreplacement of plugins with same purpose.
          #
          concerns do
            use ConvenientService::Plugins::Service::HasAmazingPrintInspect::Concern
          end

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Result::HasAmazingPrintInspect::Concern
            end

            class self::Data
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Data::HasAmazingPrintInspect::Concern
              end
            end

            class self::Message
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Message::HasAmazingPrintInspect::Concern
              end
            end

            class self::Code
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Code::HasAmazingPrintInspect::Concern
              end
            end

            class self::Status
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Status::HasAmazingPrintInspect::Concern
              end
            end
          end

          class self::Step
            include ConvenientService::Core

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
