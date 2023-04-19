# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result
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
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          def result
            success
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      specify do
        expect { method_value }.to delegate_to(ConvenientService::Service::Plugins::HasResult::Commands::IsResult, :call)
      end

      context "when `result` is NOT result" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              "string value"
            end
          end
        end

        let(:error_message) do
          <<~TEXT
            Return value of service `#{service_class}` is NOT a `Result`.
            It is `String`.

            Did you forget to call `success`, `failure`, or `error` from the `result` method?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResult::Errors::ServiceReturnValueNotKindOfResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::HasResult::Errors::ServiceReturnValueNotKindOfResult)
            .with_message(error_message)
        end
      end

      context "when `result` is result" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        it "returns original method value" do
          expect(method_value).to be_success.without_data
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
