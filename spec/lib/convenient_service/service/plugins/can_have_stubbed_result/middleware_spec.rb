# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResult::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::Results
    include ConvenientService::RSpec::Helpers::StubService

    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_class, :result, middlewares: described_class) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      ##
      # TODO: Service class factory!
      #
      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          concerns do
            use ConvenientService::Common::Plugins::HasConstructor::Concern
            use ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern
            use ConvenientService::Service::Plugins::HasResult::Concern
            use ConvenientService::Service::Plugins::CanHaveStubbedResult::Concern
          end

          middlewares :result, scope: :class do
            use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

            use ConvenientService::Service::Plugins::CanHaveStubbedResult::Middleware
          end

          # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Common::Plugins::HasInternals::Concern
              use ConvenientService::Common::Plugins::HasConstructor::Concern
              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern
            end

            middlewares :initialize do
              use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

              use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
            end

            class self::Internals
              include ConvenientService::Core

              concerns do
                use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
              end
            end
          end
          # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

          def result
            success
          end
        end
      end

      context "when cache does NOT contain any stubs" do
        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(*args, **kwargs, &block)
            .and_return_its_value
        end

        it "returns original result" do
          expect(method_value).to be_success
        end
      end

      context "when cache contains one stub" do
        context "when that one stub with different arguments" do
          before do
            stub_service(service_class)
              .with_arguments(:bar, **kwargs, &block)
              .to return_error
              .with_code(:different_arguments)
          end

          it "returns original result" do
            expect(method_value).to be_success
          end
        end

        context "when that one stub with same arguments" do
          before do
            stub_service(service_class)
              .with_arguments(*args, **kwargs, &block)
              .to return_error
              .with_code(:same_arguments)
          end

          it "returns stub with same arguments" do
            expect(method_value).to be_error.with_code(:same_arguments)
          end
        end

        context "when that one stub without arguments" do
          before do
            stub_service(service_class)
              .to return_error
              .with_code(:without_arguments)
          end

          it "returns stub without arguments" do
            expect(method_value).to be_error.with_code(:without_arguments)
          end
        end
      end

      context "when cache contains multiple stubs" do
        context "when all of them with different arguments" do
          before do
            stub_service(service_class)
              .with_arguments(:bar, **kwargs, &block)
              .to return_error
              .with_code(:different_arguments)

            stub_service(service_class)
              .with_arguments(:baz, **kwargs, &block)
              .to return_error
              .with_code(:different_arguments)
          end

          it "returns original result" do
            expect(method_value).to be_success
          end
        end

        context "when one of them with different arguments and one with same arguments" do
          before do
            stub_service(service_class)
              .with_arguments(:bar, **kwargs, &block)
              .to return_error
              .with_code(:different_arguments)

            stub_service(service_class)
              .with_arguments(*args, **kwargs, &block)
              .to return_error
              .with_code(:same_arguments)
          end

          it "returns stub with same arguments" do
            expect(method_value).to be_error.with_code(:same_arguments)
          end
        end

        context "when one of them with different arguments and one without arguments" do
          before do
            stub_service(service_class)
              .with_arguments(:bar, **kwargs, &block)
              .to return_error
              .with_code(:different_arguments)

            stub_service(service_class)
              .to return_error
              .with_code(:without_arguments)
          end

          it "returns stub without arguments" do
            expect(method_value).to be_error.with_code(:without_arguments)
          end
        end

        context "when one of them with same arguments and one without arguments" do
          before do
            stub_service(service_class)
              .with_arguments(*args, **kwargs, &block)
              .to return_error
              .with_code(:same_arguments)

            stub_service(service_class)
              .to return_error
              .with_code(:without_arguments)
          end

          it "returns stub same arguments" do
            expect(method_value).to be_error.with_code(:same_arguments)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
