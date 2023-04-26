# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RaisesOnDoubleResult::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

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
        expect(described_class.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, method_name, middlewares: described_class) }

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(result_original_value) do |result_original_value|
            include ConvenientService::Common::Plugins::HasInternals::Concern
            include ConvenientService::Service::Plugins::HasResult::Concern

            class self::Internals
              include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
            end

            define_method(:result) { result_original_value }
          end
        end
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

      let(:service_instance) { service_class.new }
      let(:result_original_value) { "result original value" }

      let(:method_name) { :result }
      let(:key) { ConvenientService::Service::Plugins::RaisesOnDoubleResult::Entities::Key.new(method: method_name, args: [], kwargs: {}, block: nil) }

      context "when service does NOT have result" do
        before do
          service_instance.internals.cache.delete(:has_result)
        end

        it "writes `true` to cache with `has_result` key" do
          allow(service_instance.internals.cache).to receive(:write).with(:has_result, true).and_call_original

          method_value

          expect(service_instance.internals.cache).to have_received(:write)
        end

        specify {
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        }
      end

      context "when service has result" do
        include ConvenientService::RSpec::Helpers::IgnoringError

        before do
          service_instance.internals.cache.write(:has_result, true)
        end

        let(:error_message) do
          <<~TEXT
            `#{service_class}` service has a double result.

            Make sure its #result calls only one from the following methods `success`, `failure`, or `error` and only once.

            Maybe you missed `return`? The most common scenario is similar to this one:

            def result
              # ...

              error unless valid?
              # instead of return error unless valid?

              success
            end
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::RaisesOnDoubleResult::Errors::DoubleResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::RaisesOnDoubleResult::Errors::DoubleResult)
            .with_message(error_message)
        end

        ##
        # NOTE: Error is NOT the purpose of this spec. That is why it is caught.
        # But if it is NOT caught, the spec should fail.
        #
        specify {
          expect { ignoring_error(ConvenientService::Service::Plugins::RaisesOnDoubleResult::Errors::DoubleResult) { method_value } }
            .not_to call_chain_next.on(method)
        }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
