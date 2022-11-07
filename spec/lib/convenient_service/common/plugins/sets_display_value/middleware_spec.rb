# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::SetsDisplayValue::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(*args, **kwargs, &block) }
      let(:args) { [] }
      let(:kwargs) { {} }
      let(:block) { proc { :foo } }
      let(:modified_kwargs) { {test: nil} }

      let(:method) { wrap_method(service_instance, :initialize, middlewares: described_class) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Common::Plugins::HasConstructor::Concern

          def initialize(*args, **kwargs, &block)
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **kwargs, &block) }

      context "when there is display argument" do
        context "when its value is true" do
          let(:kwargs) { {**modified_kwargs, display: true} }

          it "sets display instance variable in entity" do
            method_value

            expect(service_instance.instance_variable_get(:@display)).to eq(true)
          end

          specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **modified_kwargs, &block) }
        end

        context "when its value is false" do
          let(:kwargs) { {**modified_kwargs, display: false} }

          it "does NOT set display instance variable in entity" do
            method_value

            expect(service_instance.instance_variable_get(:@display)).to be_nil
          end

          specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **modified_kwargs, &block) }
        end

        context "when its value is any but NOT true" do
          let(:kwargs) { {**modified_kwargs, display: ""} }

          it "does NOT set display instance variable in entity" do
            method_value

            expect(service_instance.instance_variable_get(:@display)).to be_nil
          end

          specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **modified_kwargs, &block) }
        end
      end

      context "when there is NOT display argument" do
        let(:kwargs) { {something: nil} }

        it "does NOT set display value in entity" do
          method_value

          expect(service_instance.instance_variable_get(:@display)).to be_nil
        end

        specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **kwargs, &block) }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
