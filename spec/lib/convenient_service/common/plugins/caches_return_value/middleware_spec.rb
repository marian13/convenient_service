# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CachesReturnValue::Middleware, type: :standard do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for any_method, scope: any_scope, entity: any_entity
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

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(service_result_value, middleware) do |service_result_value, middleware|
            include ConvenientService::Service::Configs::Standard

            middlewares :result do
              observe middleware
            end

            define_method(:result) { success(value: service_result_value) }
          end
        end
      end

      let(:service_instance) { service_class.new }
      let(:service_result_value) { "service result value" }
      let(:key) { ConvenientService::Support::Cache::Entities::Caches::Hash.keygen(:return_values, :result) }

      context "when method call is NOT cached" do
        specify { expect { method_value }.to call_chain_next.on(method) }

        it "writes `chain.next` to `cache` with key" do
          expect { method_value }.to change { service_instance.internals.cache.read(key) }.from(nil).to(service_class.success(data: {value: service_result_value}))
        end

        it "returns cached value by key" do
          expect(method_value).to eq(service_instance.internals.cache.read(key))
        end
      end

      context "when method call is cached" do
        before do
          ##
          # NOTE: Calls method in order to initialize `service_instance.internals.cache`.
          #
          method_value
        end

        specify { expect { method_value }.not_to call_chain_next.on(method) }

        it "returns cached value by key" do
          expect(method_value).to eq(service_instance.internals.cache.read(key))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
