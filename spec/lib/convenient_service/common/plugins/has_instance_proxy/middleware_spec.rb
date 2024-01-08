# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasInstanceProxy::Middleware do
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
          intended_for :new, scope: :class, entity: any_entity
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

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(klass, :new, observe_middleware: middleware) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      let(:klass) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Core

            concerns do
              use ConvenientService::Common::Plugins::HasInstanceProxy::Concern
            end

            middlewares :new, scope: :class do |stack|
              stack.use_and_observe middleware
            end
          end
        end
      end

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .with_arguments(*args, **kwargs, &block)
      end

      it "returns instance proxy" do
        expect(method_value).to be_instance_of(klass.instance_proxy_class)
      end

      example_group "instance proxy" do
        it "has feature instance as target" do
          expect(method_value.instance_proxy_target).to be_instance_of(klass)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
