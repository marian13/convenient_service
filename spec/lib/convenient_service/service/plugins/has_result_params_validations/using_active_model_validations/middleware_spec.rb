# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasResultParamsValidations::UsingActiveModelValidations

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultParamsValidations::UsingActiveModelValidations::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      let(:service_class) do
        Class.new do
          include ConvenientService::Common::Plugins::HasInternals::Concern
          include ConvenientService::Service::Plugins::HasResult::Concern
          include ConvenientService::Common::Plugins::CachesConstructorParams::Concern
          include ConvenientService::Service::Plugins::HasResultParamsValidations::UsingActiveModelValidations::Concern

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Common::Plugins::HasInternals::Concern
              use ConvenientService::Common::Plugins::HasConstructor::Concern
              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
            end

            middlewares :initialize do
              use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
            end

            class self::Internals
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
              end
            end
          end

          class self::Internals
            include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end

          attr_reader :foo

          ##
          # NOTE: Rails 6 and 7 differently handle nested hashes in `validates` call. See links below.
          # - https://github.com/rails/rails/blob/v6.0.0/activemodel/lib/active_model/translation.rb#L67
          # - https://github.com/rails/rails/blob/v7.0.0/activemodel/lib/active_model/translation.rb#L67
          # - https://github.com/rails/rails/commit/4645f2d34fc1d9f037096de988e5cc5ca41a3cf3
          #
          # For example, the following works in Ruby 2.7 + Rails 6, Ruby 2.7 + Rails 7, Ruby 3.* + Rails 7,
          # but fails in Ruby 3.* and Rails 6.
          #   validates :foo, length: {maximum: 2}
          #
          # To imitate a similar behaviour in Rails 6 a custom validation can be used.
          #   validate { errors.add(:foo, "Foo length is over 2") if foo.to_s.length > 2 }
          #   validate_with LengthValidatior, fields: :foo
          #
          # More info:
          # - https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
          #
          # TODO: Add to troubleshoting.
          #
          # validates :foo, length: {maximum: 2}
          validate { errors.add(:foo, "Foo length is over 2") if foo.to_s.length > 2 }

          def initialize(foo:)
            @foo = foo
          end

          ##
          # IMPORTANT: Helps to avoid:
          # *** ArgumentError Exception: Class name cannot be blank. You need to supply a name argument when anonymous class given
          # https://stackoverflow.com/a/26168343/12201472
          # https://api.rubyonrails.org/classes/ActiveModel/Naming.html
          #
          def self.name
            "Service"
          end

          def result
            success
          end
        end
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

      context "when validation does NOT have any errors" do
        let(:service_instance) { service_class.new(foo: "x") }

        specify {
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        }
      end

      context "when validation has any error" do
        let(:service_instance) { service_class.new(foo: "bar") }

        let(:errors) { service_instance.errors.messages.transform_values(&:first) }

        it "returns failure with first error message for each invalid attribute as data" do
          expect(method_value).to be_failure.with_data(errors)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
