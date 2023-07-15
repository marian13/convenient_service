# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RaisesOnDoubleResult::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

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
          intended_for :result, entity: :service
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

      let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            middlewares :result do
              use_and_observe middleware
            end

            def result
              success
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      let(:method_name) { :result }
      let(:key) { ConvenientService::Service::Plugins::RaisesOnDoubleResult::Entities::Key.new(method: method_name, args: [], kwargs: {}, block: nil) }

      context "when service does NOT have result" do
        before do
          service_instance.internals.cache.delete(:has_j_send_result)
        end

        specify do
          expect { method_value }
            .to delegate_to(service_instance.internals.cache, :write)
            .with_arguments(:has_j_send_result, true)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        end
      end

      context "when service has result" do
        include ConvenientService::RSpec::Helpers::IgnoringError

        before do
          service_instance.internals.cache.write(:has_j_send_result, true)
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
        specify do
          expect { ignoring_error(ConvenientService::Service::Plugins::RaisesOnDoubleResult::Errors::DoubleResult) { method_value } }
            .not_to call_chain_next.on(method)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
