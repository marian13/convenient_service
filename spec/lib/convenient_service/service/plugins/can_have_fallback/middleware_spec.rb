# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveFallback::Middleware do
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
          intended_for :fallback_result, entity: :service
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

      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :fallback_result, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            middlewares :fallback_result do
              observe middleware
            end

            def fallback_result
              success
            end
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      context "when `result` is NOT success" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Configs::Standard

              middlewares :fallback_result do
                observe middleware
              end

              def fallback_result
                error
              end
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Return value of service `#{service_class}` try is NOT a `success`.
            It is `error`.

            Did you accidentally call `failure` or `error` instead of `success` from the `fallback_result` method?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::ServiceFallbackReturnValueNotSuccess`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::ServiceFallbackReturnValueNotSuccess)
            .with_message(exception_message)
        end
      end

      context "when `result` is success" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Configs::Standard

              middlewares :fallback_result do
                observe middleware
              end

              def fallback_result
                success
              end
            end
          end
        end

        let(:fallback_result) { service_instance.success }

        before do
          allow(service_instance).to receive(:success).and_return(fallback_result)
        end

        it "returns `fallback_result`" do
          expect(method_value).to eq(fallback_result)
        end

        specify do
          expect { method_value }
            .to delegate_to(fallback_result, :copy)
            .with_arguments(overrides: {kwargs: {fallback_result: true}})
        end

        it "returns result with checked status" do
          expect(method_value.has_checked_status?).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
