# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultShortSyntax::Success::Middleware do
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
          intended_for :success
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
            include ConvenientService::Configs::Standard

            middlewares :success do
              observe middleware
            end
          end
        end
      end

      specify do
        expect { method_value }
          .to delegate_to(ConvenientService::Service::Plugins::HasResultShortSyntax::Success::Commands::RefuteKwargsContainDataAndExtraKeys, :call)
          .with_arguments(kwargs: {})
      end

      context "when `kwargs` do NOT passed" do
        subject(:method_value) { method.call }

        it "returns success with default data" do
          expect(method_value).to be_success.with_data({})
        end
      end

      context "when `kwargs` are passed" do
        context "when `kwargs` do NOT contain `:data` key" do
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
        end

        context "when `kwargs` contain extra keys" do
          subject(:method_value) { method.call(data: {foo: :bar}, extra_key: "anything") }

          let(:error_message) do
            <<~TEXT
              `kwargs` passed to `success` method contain `data` and extra keys. That's NOT allowed.

              Please, consider something like:

              success(foo: :bar)
              success(data: {foo: :bar})
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasResultShortSyntax::Success::Errors::KwargsContainDataAndExtraKeys`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::HasResultShortSyntax::Success::Errors::KwargsContainDataAndExtraKeys)
              .with_message(error_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
