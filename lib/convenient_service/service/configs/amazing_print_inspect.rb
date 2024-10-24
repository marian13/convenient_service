# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module AmazingPrintInspect
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          ##
          # @internal
          #   TODO: Plugin groups for autoreplacement of plugins with same purpose.
          #
          concerns do
            use ConvenientService::Plugins::Service::HasAmazingPrintInspect::Concern
          end

          entity :Result do
            concerns do
              use ConvenientService::Plugins::Result::HasAmazingPrintInspect::Concern
            end

            entity :Data do
              concerns do
                use ConvenientService::Plugins::Data::HasAmazingPrintInspect::Concern
              end
            end

            entity :Message do
              concerns do
                use ConvenientService::Plugins::Message::HasAmazingPrintInspect::Concern
              end
            end

            entity :Code do
              concerns do
                use ConvenientService::Plugins::Code::HasAmazingPrintInspect::Concern
              end
            end

            entity :Status do
              concerns do
                use ConvenientService::Plugins::Status::HasAmazingPrintInspect::Concern
              end
            end
          end

          entity :Step do
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
