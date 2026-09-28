# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeEvaluated::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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
          intended_for :result, entity: :step
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
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :result, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(first_step, middleware) do |first_step, middleware|
            include ConvenientService::Standard::Config.with(:rollbacks)

            self::Step.class_exec(middleware) do |middleware|
              middlewares :result do
                observe middleware
              end
            end

            step first_step
          end
        end
      end

      let(:first_step) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(data: {foo: :foo, bar: :bar, baz: :baz})
          end
        end
      end

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
            .without_arguments
            .and_return { step.result }
      end

      specify do
        expect { method_value }
          .to delegate_to(step, :mark_as_evaluated!)
          .without_arguments
      end

      context "when original result raises exception" do
        before do
          first_step.commit_config!

          allow(first_step).to receive(:result).and_raise(ArgumentError)
        end

        specify do
          expect { ignoring_exception(ArgumentError) { method_value } }
            .not_to delegate_to(step, :mark_as_evaluated!)
            .with_any_arguments
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
