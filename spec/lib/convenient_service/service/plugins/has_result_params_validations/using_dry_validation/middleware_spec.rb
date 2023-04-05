# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Middleware do
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

      let(:method) { wrap_method(service_instance, method_name, middlewares: described_class) }
      let(:method_name) { :result }

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      let(:service_class) do
        Class.new do
          include ConvenientService::Common::Plugins::HasInternals::Concern
          include ConvenientService::Common::Plugins::CachesConstructorParams::Concern
          include ConvenientService::Service::Plugins::HasResult::Concern
          include ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Concern

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Common::Plugins::HasInternals::Concern
              use ConvenientService::Common::Plugins::HasConstructor::Concern
              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern
            end

            middlewares :initialize do
              use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
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

          contract do
            params do
              required(:foo).value(:string, max_size?: 2)
            end
          end

          def result
            success
          end
        end
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

      let(:service_instance) { service_class.new }

      context "when contact does NOT have schema" do
        ##
        # TODO: Factories. Highest priority.
        #
        # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
        let(:service_class) do
          Class.new do
            include ConvenientService::Common::Plugins::HasInternals::Concern
            include ConvenientService::Common::Plugins::CachesConstructorParams::Concern
            include ConvenientService::Service::Plugins::HasResult::Concern
            include ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Concern

            class self::Result
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Concern
                use ConvenientService::Common::Plugins::HasConstructor::Concern
                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern
              end

              middlewares :initialize do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
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

            def result
              success
            end
          end
        end
        # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

        before do
          service_instance.internals.cache.write(:constructor_params, ConvenientService::Common::Plugins::CachesConstructorParams::Entities::ConstructorParams.new(kwargs: {foo: "x"}))
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        end
      end

      context "when validation does NOT have any errors" do
        before do
          service_instance.internals.cache.write(:constructor_params, ConvenientService::Common::Plugins::CachesConstructorParams::Entities::ConstructorParams.new(kwargs: {foo: "x"}))
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        end
      end

      context "when validation has any error" do
        before do
          service_instance.internals.cache.write(:constructor_params, ConvenientService::Common::Plugins::CachesConstructorParams::Entities::ConstructorParams.new(kwargs: {foo: "bar"}))
        end

        let(:errors) { service_class.contract.new.call(**service_instance.constructor_params.kwargs).errors.to_h.transform_values(&:first) }

        it "returns failure with first error message for each invalid attribute as data" do
          expect(method_value).to be_failure.with_data(errors)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
