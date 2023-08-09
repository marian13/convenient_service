# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Middleware do
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
          intended_for :error, entity: :service
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

      subject(:method_value) { method.call(*args, **kwargs) }

      let(:method) { wrap_method(service_instance, :error, observe_middleware: middleware) }
      let(:service_instance) { service_class.new }
      let(:args) { [] }
      let(:kwargs) { {} }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            middlewares :error do
              observe middleware
            end
          end
        end
      end

      specify do
        expect { method_value }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Commands::AssertEitherArgsOrKwargsArePassed, :call)
          .with_arguments(args: [], kwargs: {})
      end

      specify do
        expect { method_value }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Commands::AssertArgsCountLowerThanThree, :call)
          .with_arguments(args: [])
      end

      context "when `args` are NOT passed" do
        let(:args) { [] }

        context "when `kwargs` are NOT passed" do
          let(:kwargs) { {} }

          it "returns error with default message and default code" do
            expect(method_value).to be_error.with_message("").and_code(:default_error)
          end
        end

        context "when `kwargs` are passed" do
          let(:kwargs) { {message: "Helpful text", code: :descriptive_code} }

          it "returns error with message and code" do
            expect(method_value).to be_error.with_message("Helpful text").and_code(:descriptive_code)
          end
        end
      end

      context "when `args` are passed" do
        let(:args) { ["Helpful text", :descriptive_code] }

        context "when `kwargs` are NOT passed" do
          let(:kwargs) { {} }

          context "when one arg is passed" do
            let(:args) { ["Helpful text"] }

            it "returns error with message and default code" do
              expect(method_value).to be_error.with_message("Helpful text").and_code(:default_error)
            end
          end

          context "when two args are passed" do
            let(:args) { ["Helpful text", :descriptive_code] }

            it "returns error with message and code" do
              expect(method_value).to be_error.with_message("Helpful text").and_code(:descriptive_code)
            end
          end

          context "when more than two args are passed" do
            let(:args) { ["Helpful text", :descriptive_code, "extra argument"] }

            let(:error_message) do
              <<~TEXT
                More than two `args` are passed to the `error` method.

                Did you mean something like:

                error("Helpful text")
                error("Helpful text", :descriptive_code)
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::MoreThanTwoArgsArePassed`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::MoreThanTwoArgsArePassed)
                .with_message(error_message)
            end
          end
        end

        context "when `kwargs` are passed" do
          let(:kwargs) { {message: "Helpful text", code: :descriptive_code} }

          let(:error_message) do
            <<~TEXT
              Both `args` and `kwargs` are passed to the `error` method.

              Did you mean something like:

              error("Helpful text")
              error("Helpful text", :descriptive_code)

              error(message: "Helpful text")
              error(message: "Helpful text", code: :descriptive_code)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::BothArgsAndKwargsArePassed`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::BothArgsAndKwargsArePassed)
              .with_message(error_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
