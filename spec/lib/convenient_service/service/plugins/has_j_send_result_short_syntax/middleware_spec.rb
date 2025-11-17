# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Middleware, type: :standard do
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
          intended_for [:success, :failure, :error], entity: :service
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

      let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }

      let(:service_instance) { service_class.new }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, middleware) do |method_name, middleware|
            include ConvenientService::Standard::Config

            middlewares method_name do
              observe middleware
            end
          end
        end
      end

      example_group "`success`" do
        let(:method_name) { :success }

        context "when `kwargs` are NOT passed" do
          context "when `args` are NOT passed" do
            subject(:method_value) { method.call }

            it "returns success without data" do
              expect(method_value).to be_success.without_data
            end
          end

          context "when `args` are passed" do
            context "when only one `arg` is passed" do
              subject(:method_value) { method.call("foo") }

              it "returns success with message" do
                expect(method_value).to be_success.with_message("foo")
              end
            end

            context "when only two `args` are passed" do
              subject(:method_value) { method.call("foo", :foo) }

              it "returns success with message and code" do
                expect(method_value).to be_success.with_message("foo").with_code(:foo)
              end
            end

            context "when more than two `args` are passed" do
              subject(:method_value) { method.call("foo", :foo, :bar) }

              let(:exception_message) do
                <<~TEXT
                  More than two `args` are passed to the `success` method.

                  Did you mean something like:

                  success("Helpful text")
                  success("Helpful text", :descriptive_code)
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed) { method_value } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end
          end
        end

        context "when `kwargs` are passed" do
          context "when `args` are NOT passed" do
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

                    # Shorter form with one arg. Assumes that arg is `message`.
                    success("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    success("foo", :foo)

                    # Longer form. More explicit `data`.
                    success(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    success(message: "foo")

                    # Longer form. More explicit `code`.
                    success(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    success(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    success(data: {foo: :bar}, message: "foo")
                    success(data: {foo: :bar}, code: :foo)
                    success(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
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

                    # Shorter form with one arg. Assumes that arg is `message`.
                    success("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    success("foo", :foo)

                    # Longer form. More explicit `data`.
                    success(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    success(message: "foo")

                    # Longer form. More explicit `code`.
                    success(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    success(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    success(data: {foo: :bar}, message: "foo")
                    success(data: {foo: :bar}, code: :foo)
                    success(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
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

                    # Shorter form with one arg. Assumes that arg is `message`.
                    success("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    success("foo", :foo)

                    # Longer form. More explicit `data`.
                    success(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    success(message: "foo")

                    # Longer form. More explicit `code`.
                    success(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    success(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    success(data: {foo: :bar}, message: "foo")
                    success(data: {foo: :bar}, code: :foo)
                    success(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end

          context "when `args` are passed" do
            subject(:method_value) { method.call("foo", code: :foo) }

            let(:exception_message) do
              <<~TEXT
                Both `args` and `kwargs` are passed to the `success` method.

                Did you mean something like:

                success("Helpful text")
                success("Helpful text", :descriptive_code)

                success(message: "Helpful text")
                success(message: "Helpful text", code: :descriptive_code)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed) { method_value } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end

      example_group "`failure`" do
        let(:method_name) { :failure }

        context "when `kwargs` are NOT passed" do
          context "when `args` are NOT passed" do
            subject(:method_value) { method.call }

            it "returns failure without data" do
              expect(method_value).to be_failure.without_data
            end
          end

          context "when `args` are passed" do
            context "when only one `arg` is passed" do
              subject(:method_value) { method.call("foo") }

              it "returns failure with message" do
                expect(method_value).to be_failure.with_message("foo")
              end
            end

            context "when only two `args` are passed" do
              subject(:method_value) { method.call("foo", :foo) }

              it "returns failure with message and code" do
                expect(method_value).to be_failure.with_message("foo").with_code(:foo)
              end
            end

            context "when more than two `args` are passed" do
              subject(:method_value) { method.call("foo", :foo, :bar) }

              let(:exception_message) do
                <<~TEXT
                  More than two `args` are passed to the `failure` method.

                  Did you mean something like:

                  failure("Helpful text")
                  failure("Helpful text", :descriptive_code)
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed) { method_value } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end
          end
        end

        context "when `kwargs` are passed" do
          context "when `args` are NOT passed" do
            context "when `kwargs` do NOT contain `:data`, `:message` and `code` keys" do
              subject(:method_value) { method.call(foo: :bar) }

              it "returns failure with data" do
                expect(method_value).to be_failure.with_data(foo: :bar)
              end
            end

            context "when `kwargs` contain `:data` key" do
              subject(:method_value) { method.call(data: {foo: :bar}) }

              it "returns failure with data" do
                expect(method_value).to be_failure.with_data(foo: :bar)
              end

              context "when `kwargs` contain extra keys" do
                subject(:method_value) { method.call(data: {foo: :bar}, extra_key: "anything") }

                let(:exception_message) do
                  <<~TEXT
                    `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

                    Please, consider something like:

                    # Shorter form. Assumes that all kwargs are `data`.
                    failure(foo: :bar)

                    # Shorter form with one arg. Assumes that arg is `message`.
                    failure("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    failure("foo", :foo)

                    # Longer form. More explicit `data`.
                    failure(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    failure(message: "foo")

                    # Longer form. More explicit `code`.
                    failure(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    failure(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    failure(data: {foo: :bar}, message: "foo")
                    failure(data: {foo: :bar}, code: :foo)
                    failure(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end

            context "when `kwargs` contain `:message` key" do
              subject(:method_value) { method.call(message: "foo") }

              it "returns failure with message" do
                expect(method_value).to be_failure.with_message("foo")
              end

              context "when `kwargs` contain extra keys" do
                subject(:method_value) { method.call(message: "foo", extra_key: "anything") }

                let(:exception_message) do
                  <<~TEXT
                    `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

                    Please, consider something like:

                    # Shorter form. Assumes that all kwargs are `data`.
                    failure(foo: :bar)

                    # Shorter form with one arg. Assumes that arg is `message`.
                    failure("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    failure("foo", :foo)

                    # Longer form. More explicit `data`.
                    failure(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    failure(message: "foo")

                    # Longer form. More explicit `code`.
                    failure(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    failure(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    failure(data: {foo: :bar}, message: "foo")
                    failure(data: {foo: :bar}, code: :foo)
                    failure(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end

            context "when `kwargs` contain `:code` key" do
              subject(:method_value) { method.call(code: :foo) }

              it "returns failure with code" do
                expect(method_value).to be_failure.with_code(:foo)
              end

              context "when `kwargs` contain extra keys" do
                subject(:method_value) { method.call(code: :foo, extra_key: "anything") }

                let(:exception_message) do
                  <<~TEXT
                    `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

                    Please, consider something like:

                    # Shorter form. Assumes that all kwargs are `data`.
                    failure(foo: :bar)

                    # Shorter form with one arg. Assumes that arg is `message`.
                    failure("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    failure("foo", :foo)

                    # Longer form. More explicit `data`.
                    failure(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    failure(message: "foo")

                    # Longer form. More explicit `code`.
                    failure(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    failure(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    failure(data: {foo: :bar}, message: "foo")
                    failure(data: {foo: :bar}, code: :foo)
                    failure(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end

          context "when `args` are passed" do
            subject(:method_value) { method.call("foo", code: :foo) }

            let(:exception_message) do
              <<~TEXT
                Both `args` and `kwargs` are passed to the `failure` method.

                Did you mean something like:

                failure("Helpful text")
                failure("Helpful text", :descriptive_code)

                failure(message: "Helpful text")
                failure(message: "Helpful text", code: :descriptive_code)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed) { method_value } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end

      example_group "`error`" do
        let(:method_name) { :error }

        context "when `kwargs` are NOT passed" do
          context "when `args` are NOT passed" do
            subject(:method_value) { method.call }

            it "returns error without data" do
              expect(method_value).to be_error.without_data
            end
          end

          context "when `args` are passed" do
            context "when only one `arg` is passed" do
              subject(:method_value) { method.call("foo") }

              it "returns error with message" do
                expect(method_value).to be_error.with_message("foo")
              end
            end

            context "when only two `args` are passed" do
              subject(:method_value) { method.call("foo", :foo) }

              it "returns error with message and code" do
                expect(method_value).to be_error.with_message("foo").with_code(:foo)
              end
            end

            context "when more than two `args` are passed" do
              subject(:method_value) { method.call("foo", :foo, :bar) }

              let(:exception_message) do
                <<~TEXT
                  More than two `args` are passed to the `error` method.

                  Did you mean something like:

                  error("Helpful text")
                  error("Helpful text", :descriptive_code)
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::MoreThanTwoArgsArePassed) { method_value } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end
          end
        end

        context "when `kwargs` are passed" do
          context "when `args` are NOT passed" do
            context "when `kwargs` do NOT contain `:data`, `:message` and `code` keys" do
              subject(:method_value) { method.call(foo: :bar) }

              it "returns error with data" do
                expect(method_value).to be_error.with_data(foo: :bar)
              end
            end

            context "when `kwargs` contain `:data` key" do
              subject(:method_value) { method.call(data: {foo: :bar}) }

              it "returns error with data" do
                expect(method_value).to be_error.with_data(foo: :bar)
              end

              context "when `kwargs` contain extra keys" do
                subject(:method_value) { method.call(data: {foo: :bar}, extra_key: "anything") }

                let(:exception_message) do
                  <<~TEXT
                    `kwargs` passed to `error` method contain JSend keys and extra keys. That's NOT allowed.

                    Please, consider something like:

                    # Shorter form. Assumes that all kwargs are `data`.
                    error(foo: :bar)

                    # Shorter form with one arg. Assumes that arg is `message`.
                    error("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    error("foo", :foo)

                    # Longer form. More explicit `data`.
                    error(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    error(message: "foo")

                    # Longer form. More explicit `code`.
                    error(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    error(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    error(data: {foo: :bar}, message: "foo")
                    error(data: {foo: :bar}, code: :foo)
                    error(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end

            context "when `kwargs` contain `:message` key" do
              subject(:method_value) { method.call(message: "foo") }

              it "returns error with message" do
                expect(method_value).to be_error.with_message("foo")
              end

              context "when `kwargs` contain extra keys" do
                subject(:method_value) { method.call(message: "foo", extra_key: "anything") }

                let(:exception_message) do
                  <<~TEXT
                    `kwargs` passed to `error` method contain JSend keys and extra keys. That's NOT allowed.

                    Please, consider something like:

                    # Shorter form. Assumes that all kwargs are `data`.
                    error(foo: :bar)

                    # Shorter form with one arg. Assumes that arg is `message`.
                    error("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    error("foo", :foo)

                    # Longer form. More explicit `data`.
                    error(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    error(message: "foo")

                    # Longer form. More explicit `code`.
                    error(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    error(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    error(data: {foo: :bar}, message: "foo")
                    error(data: {foo: :bar}, code: :foo)
                    error(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end

            context "when `kwargs` contain `:code` key" do
              subject(:method_value) { method.call(code: :foo) }

              it "returns error with code" do
                expect(method_value).to be_error.with_code(:foo)
              end

              context "when `kwargs` contain extra keys" do
                subject(:method_value) { method.call(code: :foo, extra_key: "anything") }

                let(:exception_message) do
                  <<~TEXT
                    `kwargs` passed to `error` method contain JSend keys and extra keys. That's NOT allowed.

                    Please, consider something like:

                    # Shorter form. Assumes that all kwargs are `data`.
                    error(foo: :bar)

                    # Shorter form with one arg. Assumes that arg is `message`.
                    error("foo")

                    # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                    error("foo", :foo)

                    # Longer form. More explicit `data`.
                    error(data: {foo: :bar})

                    # Longer form. More explicit `message`.
                    error(message: "foo")

                    # Longer form. More explicit `code`.
                    error(code: :foo)

                    # Longer form. More explicit `message` and `code` together.
                    error(message: "foo", code: :foo)

                    # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                    error(data: {foo: :bar}, message: "foo")
                    error(data: {foo: :bar}, code: :foo)
                    error(data: {foo: :bar}, message: "foo", code: :foo)
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::KwargsContainJSendAndExtraKeys) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end

          context "when `args` are passed" do
            subject(:method_value) { method.call("foo", code: :foo) }

            let(:exception_message) do
              <<~TEXT
                Both `args` and `kwargs` are passed to the `error` method.

                Did you mean something like:

                error("Helpful text")
                error("Helpful text", :descriptive_code)

                error(message: "Helpful text")
                error(message: "Helpful text", code: :descriptive_code)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Exceptions::BothArgsAndKwargsArePassed) { method_value } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
