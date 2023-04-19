# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware do
  let(:concern) { ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      it "returns intended methods" do
        expect(described_class.intended_methods.map(&:to_h)).to eq([{method: :initialize, scope: :instance}])
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_instance, :initialize, middlewares: described_class) }

      let(:service_class) do
        Class.new.tap do |service_class|
          service_class.class_exec(concern) do |concern|
            include concern

            attr_accessor :foo

            def initialize(*args, **kwargs, &block)
            end
          end
        end
      end

      let(:service_instance) { service_class.new(*args, **kwargs, &block) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      specify {
        expect { method_value }
          .to call_chain_next.on(method)
          .with_arguments(*args, **kwargs, &block)
      }

      ##
      # NOTE: disabled `RSpec/AnyInstance` in order to check method call in `initialize`.
      #
      # rubocop:disable RSpec/AnyInstance
      it "calls `assign_attributes` with `kwargs` (from `ActiveModel::AttributeAssignment`)" do
        ##
        # https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/working-with-legacy-code/any-instance
        # https://stackoverflow.com/questions/40025889/rspec-how-to-test-if-object-sends-messages-to-self-in-initialize
        #
        expect_any_instance_of(service_class).to receive(:assign_attributes).with(kwargs).and_call_original

        method_value
      end
      # rubocop:enable RSpec/AnyInstance
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
