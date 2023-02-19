# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::WrapMethod::Entities::WrappedMethod do
  include ConvenientService::RSpec::Matchers::CacheItsValue

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
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "instance methods" do
    ##
    # TODO: Specs.
    #

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

        it "returns chain value" do
          expect(method.chain_value).to eq(:original_result_value)
        end

        specify do
          expect { method.chain_value }.to cache_its_value
        end
      end
    end

    describe "#chain_args" do
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

        it "returns chain args" do
          expect(method.chain_args).to eq(args)
        end

        specify do
          expect { method.chain_args }.to cache_its_value
        end
      end
    end

    describe "#chain_kwargs" do
      let(:service_class) do
        Class.new do
          def result(**kwargs)
            :original_result_value
          end
        end
      end

      context "when chain is NOT called" do
        let(:error_message) do
          <<~TEXT
            Chain attribute `kwargs` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess`" do
          expect { method.chain_kwargs }
            .to raise_error(ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess)
            .with_message(error_message)
        end
      end

      context "when chain is called" do
        before do
          method.call(**kwargs)
        end

        it "returns chain kwargs" do
          expect(method.chain_kwargs).to eq(kwargs)
        end

        specify do
          expect { method.chain_block }.to cache_its_value
        end
      end
    end

    describe "#chain_block" do
      let(:service_class) do
        Class.new do
          def result(&block)
            :original_result_value
          end
        end
      end

      context "when chain is NOT called" do
        let(:error_message) do
          <<~TEXT
            Chain attribute `block` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess`" do
          expect { method.chain_block }
            .to raise_error(ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess)
            .with_message(error_message)
        end
      end

      context "when chain is called" do
        before do
          method.call(&block)
        end

        it "returns chain block" do
          expect(method.chain_block).to eq(block)
        end

        specify do
          expect { method.chain_block }.to cache_its_value
        end
      end
    end

    describe "#chain_exception" do
      let(:service_class) do
        Class.new do
          def result
            raise StandardError, "exception message"
          end
        end
      end

      let(:exception) { service_class.new.result }

      context "when chain is NOT called" do
        let(:error_message) do
          <<~TEXT
            Chain attribute `exception` is accessed before the chain is called.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess`" do
          expect { method.chain_exception }
            .to raise_error(ConvenientService::RSpec::Helpers::Custom::WrapMethod::Errors::ChainAttributePreliminaryAccess)
            .with_message(error_message)
        end
      end

      context "when chain is called" do
        before do
          ignoring_error(exception.class) { method.call }
        end

        it "returns chain exception" do
          expect(method.chain_exception).to eq(exception)
        end

        specify do
          expect { method.chain_exception }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
