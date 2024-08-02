# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Inspect
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include ConvenientService::Core

          concerns do
            use ConvenientService::Plugins::Service::HasInspect::Concern
          end

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Result::HasInspect::Concern
            end

            class self::Data
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Data::HasInspect::Concern
              end
            end

            class self::Message
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Message::HasInspect::Concern
              end
            end

            class self::Code
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Code::HasInspect::Concern
              end
            end

            class self::Status
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Status::HasInspect::Concern
              end
            end
          end

          class self::Step
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Step::HasInspect::Concern
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
