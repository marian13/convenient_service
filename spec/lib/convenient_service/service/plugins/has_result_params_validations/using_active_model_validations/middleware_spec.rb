# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

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

          class self::Internals
            include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end

          attr_reader :foo

          validates :foo, length: {maximum: 2}

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
