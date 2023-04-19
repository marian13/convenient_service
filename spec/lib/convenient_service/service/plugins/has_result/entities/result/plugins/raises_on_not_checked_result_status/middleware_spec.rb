# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :data
          intended_for :message
          intended_for :code
        end
      end

      it "returns intended methods" do
        expect(described_class.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(result_instance, method_name, middlewares: described_class) }

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

      let(:method_name) { :data }

      context "when result does NOT have checked status" do
        before do
          result_instance.internals.cache.delete(:has_checked_status)
        end

        let(:error_message) do
          <<~TEXT
            Attribute `#{method_name}` is accessed before result status is checked.

            Did you forget to call `success?`, `failure?`, or `error?` on result?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Errors::StatusIsNotChecked`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Errors::StatusIsNotChecked)
            .with_message(error_message)
        end
      end

      context "when result has checked status" do
        before do
          result_instance.internals.cache.write(:has_checked_status, true)
        end

        specify {
          expect { method_value }
            .to call_chain_next.on(method)
            .and_return_its_value
        }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
