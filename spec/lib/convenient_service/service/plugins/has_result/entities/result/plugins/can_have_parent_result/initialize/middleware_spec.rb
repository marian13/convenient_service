# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanHaveParentResult::Initialize::Middleware do
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
          intended_for :initialize
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

      subject(:method_value) { method.call(**attributes) }

      let(:method) { wrap_method(result, :initialize, middleware: middleware) }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            self::Result.class_exec(middleware) do |middleware|
              middlewares :initialize do
                observe middleware
              end
            end

            def result
              success
            end
          end
        end
      end

      let(:result) { service.result }

      context "when `parent` is NOT passed" do
        let(:attributes) { result.jsend_attributes.to_h }

        specify do
          expect { method_value }
            .to delegate_to(result.internals.cache, :write)
            .with_arguments(:parent, nil)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**attributes)
            .and_return_its_value
        end
      end

      context "when `parent` is passed" do
        let(:attributes) { result.jsend_attributes.to_h.merge(parent: parent) }
        let(:parent) { double }

        specify do
          expect { method_value }
            .to delegate_to(result.internals.cache, :write)
            .with_arguments(:parent, parent)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**attributes)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
