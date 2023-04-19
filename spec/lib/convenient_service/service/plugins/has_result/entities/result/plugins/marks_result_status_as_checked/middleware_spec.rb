# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(result_instance, :success?, middlewares: described_class) }

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      let(:result_class) do
        Class.new do
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
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

      let(:result_instance) { result_class.new(**params) }

      ##
      # TODO: Result factory.
      #
      let(:params) do
        {
          service: double,
          status: :foo,
          data: {foo: :bar},
          message: "foo",
          code: :foo
        }
      end

      it "writes `true` to cache with `has_checked_status` key" do
        allow(result_instance.internals.cache).to receive(:write).with(:has_checked_status, true).and_call_original

        method_value

        expect(result_instance.internals.cache).to have_received(:write)
      end

      specify {
        expect { method_value }
          .to call_chain_next.on(method)
          .and_return_its_value
      }
    end
  end
end
