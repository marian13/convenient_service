# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CachesConstructorParams::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_instance, :initialize, middlewares: described_class) }

      # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
      let(:service_class) do
        Class.new do
          include ConvenientService::Common::Plugins::HasInternals::Concern
          include ConvenientService::Common::Plugins::CachesConstructorParams::Concern

          class self::Internals
            include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end

          def initialize(*args, **kwargs, &block)
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

      let(:service_instance) { service_class.new }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **kwargs, &block) }

      it "writes `ConvenientService::Common::Plugins::CachesConstructorParams::Entities::ConstructorParams` instance to cache with `constructor_params` as key" do
        expect { method_value }
          .to delegate_to(service_instance.internals.cache, :write)
          .with_arguments(:constructor_params, ConvenientService::Common::Plugins::CachesConstructorParams::Entities::ConstructorParams.new(args: args, kwargs: kwargs, block: block))
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
