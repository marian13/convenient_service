# frozen_string_literal: true

module ConvenientService
  module Configs
    ##
    # TODO: Complete.
    #
    module AwesomePrintInspect
      include Support::Concern

      # rubocop:disable Lint/ConstantDefinitionInBlock
      included do
        include Configs::Minimal

        concerns do
          ##
          # TODO: Safe replace.
          #
          replace Plugins::Service::HasInspect::Concern, Plugins::Service::HasAwesomePrintInspect::Concern
        end

        class self::Result
          concerns do
            replace Plugins::Result::HasInspect::Concern, Plugins::Result::HasAwesomePrintInspect::Concern
          end

          # class self::Data
          #   concerns do
          #     replace HasInspect::Concern, HasAwesomePrintInspect::Concern
          #   end
          # end
          #
          # class self::Message
          #   concerns do
          #     replace HasInspect::Concern, HasAwesomePrintInspect::Concern
          #   end
          # end
          #
          # class self::Code
          #   concerns do
          #     replace HasInspect::Concern, HasAwesomePrintInspect::Concern
          #   end
          # end
          #
          # class self::Status
          #   concerns do
          #     replace HasInspect::Concern, HasAwesomePrintInspect::Concern
          #   end
          # end
        end

        class self::Step
          concerns do
            replace Plugins::Step::HasInspect::Concern, Plugins::Step::HasAwesomePrintInspect::Concern
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end
  end
end
