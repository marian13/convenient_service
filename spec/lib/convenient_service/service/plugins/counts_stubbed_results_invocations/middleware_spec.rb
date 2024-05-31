# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CountsStubbedResultsInvocations::Middleware, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result, scope: any_scope, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::StubService
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call(*result_arguments.args, **result_arguments.kwargs, &result_arguments.block) }

        let(:method) { wrap_method(entity, :result, observe_middleware: middleware) }

        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware, scope) do |middleware, scope|
              include ConvenientService::Standard::Config

              middlewares :result, scope: scope do
                observe middleware
              end

              def result
                success
              end
            end
          end
        end

        context "when result is NOT stubbed result" do
          let(:result) { service_class.success }

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .with_arguments(*result_arguments.args, **result_arguments.kwargs, &result_arguments.block)
              .and_return_its_value
          end

          specify do
            allow(entity).to receive(:result).and_return(result)

            expect { method_value }.not_to delegate_to(result, :stubbed_result_invocations_counter)
          end
        end

        context "when result is stubbed result" do
          let(:result) { service_class.result }

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .with_arguments(*result_arguments.args, **result_arguments.kwargs, &result_arguments.block)
              .and_return_its_value
          end

          it "increments stubbed result invocations counter" do
            stub_service(service_class).to return_error

            expect { method_value }.to change { result.stubbed_result_invocations_counter.current_value }.by(1)
          end
        end
      end
    end
  end

  context "when entity is service class" do
    include_examples "verify middleware behavior" do
      let(:entity) { service_class }
      let(:scope) { :class }

      let(:result_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }
    end
  end

  context "when entity is service instance" do
    include_examples "verify middleware behavior" do
      let(:entity) { service_instance }
      let(:scope) { :instance }

      let(:result_arguments) { ConvenientService::Support::Arguments.null_arguments }

      let(:service_instance) { service_class.new(*args, **kwargs, &block) }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
