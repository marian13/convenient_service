# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::WrapMethod::Entities::WrappedMethod do
  subject(:method) { described_class.new(entity: entity, method: method_name, middlewares: middlewares) }

  let(:service_class) do
    Class.new do
      def result
        :original_result_value
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:entity) { service_instance }
  let(:method_name) { :result }
  let(:middlewares) { [] }

  let(:args) { [:foo] }

  example_group "instance methods" do
    describe "#chain_called?" do
      context "when chain is NOT called" do
        it "returns `false`" do
          expect(method.chain_called?).to eq(false)
        end
      end

      context "when chain is called" do
        before do
          method.call
        end

        it "returns `true`" do
          expect(method.chain_called?).to eq(true)
        end
      end
    end

    describe "#chain_value" do
      context "when chain is NOT called" do
        let(:error_message) do
          <<~TEXT
            Chain attribute `value` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess`" do
          expect { method.chain_value }
            .to raise_error(ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess)
            .with_message(error_message)
        end
      end

      context "when chain is called" do
        before do
          method.call
        end

        it "returns `true`" do
          expect(method.chain_value).to eq(:original_result_value)
        end
      end
    end

    describe "#chain_value" do
      let(:service_class) do
        Class.new do
          def result(*args)
            :original_result_value
          end
        end
      end

      context "when chain is NOT called" do
        let(:error_message) do
          <<~TEXT
            Chain attribute `args` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess`" do
          expect { method.chain_args }
            .to raise_error(ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess)
            .with_message(error_message)
        end
      end

      context "when chain is called" do
        before do
          method.call(*args)
        end

        it "returns `true`" do
          expect(method.chain_args).to eq(args)
        end
      end
    end

    ##
    # TODO: Specs.
    #
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
