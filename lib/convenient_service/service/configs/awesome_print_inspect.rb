# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      ##
      # Patches services to use Awesome Print to generate colored `inspect` strings.
      # Useful for debugging.
      # Works as expected for `byebug` and `pry`.
      #
      # Has issues with escaping colors for `binding.break` and `irb`.
      # There is a workaround in the examples, but its possible negative outcome has not been investigated yet. Use it at your own risk.
      #
      # @example `AwesomePrintInspect` output for `byebug` or `pry`.
      #   class Service
      #     include ::ConvenientService::Standard::Config
      #     include ::ConvenientService::AwesomePrintInspect::Config
      #
      #     def result
      #       success(foo: :bar)
      #     end
      #   end
      #
      #   Service.result
      #   # =>
      #   {
      #     :ConvenientService => {
      #            :entity => "Result",
      #           :service => "Service",
      #            :status => :success,
      #         :data_keys => [
      #             [0] :foo
      #         ]
      #     }
      #   }
      #
      # @example `AwesomePrintInspect` output for `binding.break` or `irb`.
      #
      #   class Service
      #     include ::ConvenientService::Standard::Config
      #     include ::ConvenientService::AwesomePrintInspect::Config
      #
      #     def result
      #       success(foo: :bar)
      #     end
      #   end
      #
      #   Service.result
      #   # =>
      #   {
      #     :ConvenientService^[[0;37m => ^[[0m{
      #            :entity^[[0;37m => ^[[0m^[[0;33m"Result"^[[0m,
      #           :service^[[0;37m => ^[[0m^[[0;33m"Service"^[[0m,
      #            :status^[[0;37m => ^[[0m^[[0;36m:success^[[0m,
      #         :data_keys^[[0;37m => ^[[0m[
      #             ^[[1;37m[0] ^[[0m^[[0;36m:foo^[[0m
      #         ]
      #       }
      #   }
      #
      # @example `AwesomePrintInspect` output for `binding.break` or `irb` with `Reline` hack.
      #
      #   class Service
      #     include ::ConvenientService::Standard::Config
      #     include ::ConvenientService::AwesomePrintInspect::Config
      #
      #     def result
      #       success(foo: :bar)
      #     end
      #   end
      #
      #   class Reline::Unicode
      #     def self.escape_for_print(str)
      #       str
      #     end
      #   end
      #
      #   Service.result
      #   # =>
      #   {
      #     :ConvenientService => {
      #            :entity => "Result",
      #           :service => "Service",
      #            :status => :success,
      #         :data_keys => [
      #             [0] :foo
      #         ]
      #     }
      #   }
      #
      # @see https://github.com/awesome-print/awesome_print
      # @see https://github.com/ruby/irb/blob/v1.13.1/lib/irb/inspector.rb#L113
      # @see https://github.com/ruby/irb/blob/v1.13.1/lib/irb/color.rb#L150
      # @see https://github.com/ruby/reline/blob/v0.5.8/lib/reline/unicode.rb#L30
      #
      module AwesomePrintInspect
        include Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          ##
          # @internal
          #   TODO: Plugin groups for autoreplacement of plugins with same purpose.
          #
          concerns do
            use ConvenientService::Plugins::Service::HasAwesomePrintInspect::Concern
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Result::HasAwesomePrintInspect::Concern
            end

            class self::Data
              concerns do
                use ConvenientService::Plugins::Data::HasAwesomePrintInspect::Concern
              end
            end

            class self::Message
              concerns do
                use ConvenientService::Plugins::Message::HasAwesomePrintInspect::Concern
              end
            end

            class self::Code
              concerns do
                use ConvenientService::Plugins::Code::HasAwesomePrintInspect::Concern
              end
            end

            class self::Status
              concerns do
                use ConvenientService::Plugins::Status::HasAwesomePrintInspect::Concern
              end
            end
          end

          class self::Step
            concerns do
              use ConvenientService::Plugins::Step::HasAwesomePrintInspect::Concern
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
