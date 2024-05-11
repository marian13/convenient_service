# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveFallbacks::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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
          intended_for [:fallback_failure_result, :fallback_error_result], entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::DelegateTo
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call }

        let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware.with(status: status)) }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(status, method_name, middleware) do |status, method_name, middleware|
              include ConvenientService::Service::Configs::Standard

              middlewares method_name do
                observe middleware.with(status: status)
              end

              define_method(method_name) { success }
            end
          end
        end

        let(:service_instance) { service_class.new }

        specify do
          expect { method_value }.to call_chain_next.on(method)
        end

        context "when `result` is NOT success" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(status, method_name, middleware) do |status, method_name, middleware|
                include ConvenientService::Service::Configs::Standard

                middlewares method_name do
                  observe middleware.with(status: status)
                end

                define_method(method_name) { error }
              end
            end
          end

          let(:exception_message) do
            <<~TEXT
              Return value of service `#{service_class}` `#{status}` fallback is NOT a `success`.
              It is `error`.

              Did you accidentally call `failure` or `error` instead of `success` from the `#{method_name}` method?
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::ServiceFallbackReturnValueNotSuccess`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::ServiceFallbackReturnValueNotSuccess)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveFallbacks::Exceptions::ServiceFallbackReturnValueNotSuccess) { method_value } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `result` is success" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(status, method_name, middleware) do |status, method_name, middleware|
                include ConvenientService::Service::Configs::Standard

                middlewares method_name do
                  observe middleware.with(status: status)
                end

                define_method(method_name) { success }
              end
            end
          end

          let(:fallback_result) { service_instance.success }

          before do
            allow(service_instance).to receive(:success).and_return(fallback_result)
          end

          it "returns `fallback_result`" do
            expect(method_value).to eq(fallback_result)
          end

          specify do
            expect { method_value }
              .to delegate_to(fallback_result, :copy)
              .with_arguments(overrides: {kwargs: {method_name => true}})
          end

          it "returns result with checked status" do
            expect(method_value.checked?).to eq(true)
          end
        end
      end
    end
  end

  context "when status is failure" do
    include_examples "verify middleware behavior" do
      let(:status) { :failure }
      let(:method_name) { :fallback_failure_result }
    end
  end

  context "when status is error" do
    include_examples "verify middleware behavior" do
      let(:status) { :error }
      let(:method_name) { :fallback_error_result }
    end
  end
end
# rubocop:enable RSpec/NestedGroups
