# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:concern) { ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern }
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
          intended_for :initialize, entity: any_entity
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

      let(:method) { wrap_method(service_instance, :initialize, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |service_class|
          service_class.class_exec(concern, middleware) do |concern, middleware|
            include ConvenientService::Configs::Standard

            concerns do
              use concern
            end

            middlewares :initialize do
              use_and_observe middleware
            end

            attr_accessor :foo
          end
        end
      end

      let(:service_instance) { service_class.new(*args, **kwargs, &block) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .with_arguments(*args, **kwargs, &block)
      end

      specify do
        expect { method_value }
          .to delegate_to(service_instance, :assign_attributes)
          .with_arguments(kwargs)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
