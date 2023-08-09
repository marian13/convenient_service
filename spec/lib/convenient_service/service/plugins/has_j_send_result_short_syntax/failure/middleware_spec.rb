# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Middleware do
  include ConvenientService::RSpec::Helpers::IgnoringException

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
          intended_for :failure, entity: :service
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
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :failure, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            middlewares :failure do
              observe middleware
            end
          end
        end
      end

      context "when `kwargs` do NOT passed" do
        subject(:method_value) { method.call }

        it "returns failure with default data" do
          expect(method_value).to be_failure.with_data({})
        end

        it "returns failure with default message" do
          expect(method_value).to be_failure.with_message("")
        end
      end

      context "when `kwargs` are passed" do
        context "when `kwargs` do NOT contain `:data` key" do
          subject(:method_value) { method.call(foo: :bar) }

          it "returns failure with data" do
            expect(method_value).to be_failure.with_data(foo: :bar)
          end

          it "returns failure with message" do
            expect(method_value).to be_failure.with_message("foo bar")
          end
        end

        context "when `kwargs` contain `:data` key" do
          subject(:method_value) { method.call(data: {foo: :bar}) }

          specify do
            expect { method_value }
              .to delegate_to(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Commands::AssertKwargsContainOnlyJSendKeys, :call)
              .with_arguments(kwargs: {data: {foo: :bar}})
          end

          it "returns failure with data" do
            expect(method_value).to be_failure.with_data(foo: :bar)
          end

          context "when `kwargs` contain `:message` key" do
            subject(:method_value) { method.call(data: {foo: :bar}, message: "foo") }

            it "returns failure with data" do
              expect(method_value).to be_failure.with_data(foo: :bar).and_message("foo")
            end
          end
        end

        context "when `kwargs` contain non JSend key" do
          subject(:method_value) { method.call(data: {foo: :bar}, non_jsend_key: "anything") }

          let(:error_message) do
            <<~TEXT
              When `kwargs` with `data` key are passed to `failure` method, they can NOT contain non JSend keys like `:non_jsend_key`.

              Please, consider something like:

              failure(foo: :bar) # short version does NOT support custom message
              failure(data: {foo: :bar}) # long version
              failure(data: {foo: :bar}, message: "foo") # long version with custom message
            TEXT
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainNonJSendKey) { method_value } }
              .to delegate_to(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Commands::AssertKwargsContainOnlyJSendKeys, :call)
              .with_arguments(kwargs: {data: {foo: :bar}, non_jsend_key: "anything"})
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainNonJSendKey`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainNonJSendKey)
              .with_message(error_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
