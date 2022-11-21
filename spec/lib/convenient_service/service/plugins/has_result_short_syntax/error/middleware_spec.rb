# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call(*args, **kwargs) }

      let(:method) { wrap_method(service_instance, :error, middlewares: described_class) }
      let(:service_instance) { service_class.new }
      let(:args) { [] }
      let(:kwargs) { {} }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Plugins::HasResult::Concern

          # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
          class self::Result
            include ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
          end
          # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
        end
      end

      it "delegates to `ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Commands::AssertEitherArgsOrKwargsArePassed`" do
        allow(ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Commands::AssertEitherArgsOrKwargsArePassed).to receive(:call).with(hash_including(args: [], kwargs: {})).and_call_original

        method_value

        expect(ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Commands::AssertEitherArgsOrKwargsArePassed).to have_received(:call)
      end

      it "delegates to `ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Commands::AssertArgsCountLowerThanThree`" do
        allow(ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Commands::AssertArgsCountLowerThanThree).to receive(:call).with(hash_including(args: [])).and_call_original

        method_value

        expect(ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Commands::AssertArgsCountLowerThanThree).to have_received(:call)
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

            it "raises `ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Errors::MoreThanTwoArgsArePassed`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Errors::MoreThanTwoArgsArePassed)
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

          it "raises `ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Errors::BothArgsAndKwargsArePassed`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Errors::BothArgsAndKwargsArePassed)
              .with_message(error_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
