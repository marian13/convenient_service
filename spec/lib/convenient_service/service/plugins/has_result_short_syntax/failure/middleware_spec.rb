# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :failure, middlewares: described_class) }

      let(:service_instance) { service_class.new }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Plugins::HasResult::Concern

          # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Common::Plugins::HasInternals::Concern
              use ConvenientService::Common::Plugins::HasConstructor::Concern
              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
            end

            middlewares :initialize do
              use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
            end

            class self::Internals
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
              end
            end
          end
          # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
        end
      end

      it "delegates to `ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Commands::RefuteKwargsContainDataAndExtraKeys`" do
        allow(ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Commands::RefuteKwargsContainDataAndExtraKeys).to receive(:call).with(hash_including(kwargs: {})).and_call_original

        method_value

        expect(ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Commands::RefuteKwargsContainDataAndExtraKeys).to have_received(:call)
      end

      context "when `kwargs` do NOT passed" do
        subject(:method_value) { method.call }

        it "returns failure with default data" do
          expect(method_value).to be_failure.with_data({})
        end
      end

      context "when `kwargs` are passed" do
        context "when `kwargs` do NOT contain `:data` key" do
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
        end

        context "when `kwargs` contain extra keys" do
          subject(:method_value) { method.call(data: {foo: :bar}, extra_key: "anything") }

          let(:error_message) do
            <<~TEXT
              `kwargs` passed to `failure` method contain `data` and extra keys. That's NOT allowed.

              Please, consider something like:

              failure(foo: :bar)
              failure(data: {foo: :bar})
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Errors::KwargsContainDataAndExtraKeys`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Errors::KwargsContainDataAndExtraKeys)
              .with_message(error_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
