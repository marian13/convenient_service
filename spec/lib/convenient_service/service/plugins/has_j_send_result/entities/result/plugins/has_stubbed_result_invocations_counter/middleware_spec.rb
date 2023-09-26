# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStubbedResultInvocationsCounter::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

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
          intended_for :initialize, entity: :result
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

      subject(:method_value) { method.call(**kwargs) }

      let(:method) { wrap_method(result, :initialize, observe_middleware: middleware) }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Service::Configs::Standard

            self::Result.class_exec(middleware) do |middleware|
              middlewares :initialize do
                observe middleware
              end
            end

            def result
              success
            end
          end
        end
      end

      let(:result) { service.result }

      context "when `stubbed_result` is NOT passed" do
        let(:kwargs) do
          {
            service: double,
            status: :foo,
            data: {foo: :bar},
            message: "foo",
            code: :foo
          }
        end

        it "does NOT set stubbed result counter" do
          method_value

          expect(result.stubbed_result_invocations_counter).to be_nil
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**kwargs)
            .and_return_its_value
        end
      end

      context "when `stubbed_result` is NOT `false`" do
        let(:kwargs) do
          {
            service: double,
            status: :foo,
            data: {foo: :bar},
            message: "foo",
            code: :foo,
            stubbed_result: false
          }
        end

        it "does NOT set stubbed result counter" do
          method_value

          expect(result.stubbed_result_invocations_counter).to be_nil
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**kwargs)
            .and_return_its_value
        end
      end

      context "when `stubbed_result` is `true`" do
        let(:kwargs) do
          {
            service: double,
            status: :foo,
            data: {foo: :bar},
            message: "foo",
            code: :foo,
            stubbed_result: true
          }
        end

        it "sets stubbed result counter" do
          method_value

          expect(result.stubbed_result_invocations_counter).to be_instance_of(ConvenientService::Support::ThreadSafeCounter)
        end

        ##
        # TODO: Partial matching for `delegate_to`, for `call_chain_next`.
        # TODO: `.with_arguments(**kwargs.merge(stubbed_result_invocations_counter: be_instance_of(ConvenientService::Support::ThreadSafeCounter)))`.
        #
        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
