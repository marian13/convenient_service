# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Inspect
        include Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          concerns do
            use ConvenientService::Plugins::Service::HasInspect::Concern
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Result::HasInspect::Concern
            end

            class self::Data
              concerns do
                use ConvenientService::Plugins::Data::HasInspect::Concern
              end
            end

            class self::Message
              concerns do
                use ConvenientService::Plugins::Message::HasInspect::Concern
              end
            end

            class self::Code
              concerns do
                use ConvenientService::Plugins::Code::HasInspect::Concern
              end
            end

            class self::Status
              concerns do
                use ConvenientService::Plugins::Status::HasInspect::Concern
              end
            end
          end

          class self::Step
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
