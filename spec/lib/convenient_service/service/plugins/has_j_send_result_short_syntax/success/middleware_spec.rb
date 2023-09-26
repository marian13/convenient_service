# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Middleware do
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
          intended_for :success, entity: :service
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

      let(:method) { wrap_method(service_instance, :success, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Service::Configs::Standard

            middlewares :success do
              observe middleware
            end
          end
        end
      end

      specify do
        expect { method_value }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Commands::RefuteKwargsContainJSendAndExtraKeys, :call)
          .with_arguments(kwargs: {})
      end

      context "when `kwargs` are NOT passed" do
        subject(:method_value) { method.call }

        it "returns success without data" do
          expect(method_value).to be_success.without_data
        end
      end

      context "when `kwargs` are passed" do
        context "when `kwargs` do NOT contain `:data`, `:message` and `code` keys" do
          subject(:method_value) { method.call(foo: :bar) }

          it "returns success with data" do
            expect(method_value).to be_success.with_data(foo: :bar)
          end
        end

        context "when `kwargs` contain `:data` key" do
          subject(:method_value) { method.call(data: {foo: :bar}) }

          it "returns success with data" do
            expect(method_value).to be_success.with_data(foo: :bar)
          end

          context "when `kwargs` contain extra keys" do
            subject(:method_value) { method.call(data: {foo: :bar}, extra_key: "anything") }

            let(:exception_message) do
              <<~TEXT
                `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

                Please, consider something like:

                # Shorter form. Assumes that all kwargs are `data`.
                success(foo: :bar)

                # Longer form. More explicit.
                success(data: {foo: :bar})

                # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
                success(data: {foo: :bar}, message: "foo")
                success(data: {foo: :bar}, code: :foo)
                success(data: {foo: :bar}, message: "foo", code: :foo)
                success(message: "foo")
                success(code: :foo)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys)
                .with_message(exception_message)
            end
          end
        end

        context "when `kwargs` contain `:message` key" do
          subject(:method_value) { method.call(message: "foo") }

          it "returns success with message" do
            expect(method_value).to be_success.with_message("foo")
          end

          context "when `kwargs` contain extra keys" do
            subject(:method_value) { method.call(message: "foo", extra_key: "anything") }

            let(:exception_message) do
              <<~TEXT
                `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

                Please, consider something like:

                # Shorter form. Assumes that all kwargs are `data`.
                success(foo: :bar)

                # Longer form. More explicit.
                success(data: {foo: :bar})

                # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
                success(data: {foo: :bar}, message: "foo")
                success(data: {foo: :bar}, code: :foo)
                success(data: {foo: :bar}, message: "foo", code: :foo)
                success(message: "foo")
                success(code: :foo)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys)
                .with_message(exception_message)
            end
          end
        end

        context "when `kwargs` contain `:code` key" do
          subject(:method_value) { method.call(code: :foo) }

          it "returns success with code" do
            expect(method_value).to be_success.with_code(:foo)
          end

          context "when `kwargs` contain extra keys" do
            subject(:method_value) { method.call(code: :foo, extra_key: "anything") }

            let(:exception_message) do
              <<~TEXT
                `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

                Please, consider something like:

                # Shorter form. Assumes that all kwargs are `data`.
                success(foo: :bar)

                # Longer form. More explicit.
                success(data: {foo: :bar})

                # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
                success(data: {foo: :bar}, message: "foo")
                success(data: {foo: :bar}, code: :foo)
                success(data: {foo: :bar}, message: "foo", code: :foo)
                success(message: "foo")
                success(code: :foo)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys)
                .with_message(exception_message)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
