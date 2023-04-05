# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Plugins::HasResult::Concern

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

      let(:service_instance) { service_class.new }

      specify { expect { method_value }.to call_chain_next.on(method) }

      context "when `result` class does NOT include `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern

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
              "string value"
            end
          end
        end

        let(:error_message) do
          <<~TEXT
            Return value of service `#{service_class}` is NOT a `Result`.
            It is a `String`.

            Did you forget to call `success`, `failure`, or `error` from the `result` method?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResult::Errors::ServiceReturnValueNotKindOfResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::HasResult::Errors::ServiceReturnValueNotKindOfResult)
            .with_message(error_message)
        end
      end

      context "when `result` class includes `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Service::Plugins::HasResult::Concern

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

        it "returns original method value" do
          expect(method_value).to be_success
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
