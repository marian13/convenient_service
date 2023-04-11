# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CachesReturnValue::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, method_name, middlewares: described_class) }
      let(:method_name) { :result }

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, service_result_value) do |method_name, service_result_value|
            include ConvenientService::Common::Plugins::HasInternals::Concern

            class self::Internals
              include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
            end

            define_method(method_name) { service_result_value }
          end
        end
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

      let(:service_instance) { service_class.new }
      let(:service_result_value) { "service result value" }
      let(:key) { ConvenientService::Support::Cache::Entities::Caches::Hash.keygen(:return_values, method_name) }

      context "when method call is NOT cached" do
        specify { expect { method_value }.to call_chain_next.on(method) }

        it "writes `chain.next` to `cache` with key" do
          expect { method_value }.to change { service_instance.internals.cache.read(key) }.from(nil).to(service_result_value)
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
