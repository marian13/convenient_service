# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Middleware do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }
      let(:method_name) { :result }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            concerns do
              use ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Concern
            end

            middlewares :result do
              use_and_observe middleware
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
      end

      let(:service_instance) { service_class.new }

      context "when contact does NOT have schema" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              concerns do
                use ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Concern
              end

              middlewares :result do
                use_and_observe middleware
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
        end

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
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
