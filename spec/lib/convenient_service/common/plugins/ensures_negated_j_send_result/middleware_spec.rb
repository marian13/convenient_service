# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::EnsuresNegatedJSendResult::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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
          intended_for :negated_result, entity: any_entity
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

      let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }
      let(:method_name) { :negated_result }

      let(:service_instance) { service_class.new }

      context "when result is NOT already negated" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :negated_result do
                observe middleware
              end

              def negated_result
                success
              end
            end
          end
        end

        specify do
          expect { method_value }.to call_chain_next.on(method)
        end

        it "returns negated result" do
          expect(method_value.negated?).to eq(true)
        end
      end

      context "when result is already negated" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :negated_result do
                observe middleware
              end

              def negated_result
                success.negated_result
              end
            end
          end
        end

        specify do
          expect { method_value }.to call_chain_next.on(method)
        end

        it "returns negated result" do
          expect(method_value.negated?).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
