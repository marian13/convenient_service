# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Middleware do
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
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :result, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(first_step, middleware) do |first_step, middleware|
            include ConvenientService::Configs::Standard

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
          include ConvenientService::Configs::Standard

          def result
            success(from: :result)
          end

          def try_result
            success(from: :try_result)
          end
        end
      end

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .without_arguments
      end

      context "when step is NOT try step" do
        it "returns result" do
          expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
        end
      end

      context "when step is try step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, middleware) do |first_step, middleware|
              include ConvenientService::Configs::Standard

              self::Step.class_exec(middleware) do |middleware|
                middlewares :result do
                  observe middleware
                end
              end

              step first_step, try: true
            end
          end
        end

        context "when result is NOT successful" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Configs::Standard

              def result
                failure(from: :result)
              end

              def try_result
                success(from: :try_result)
              end
            end
          end

          it "returns result" do
            expect(method_value).to be_success.with_data(from: :try_result).of_step(first_step)
          end

          specify do
            expect { method_value }
              .to delegate_to(step, :try_result)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result is successful" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Configs::Standard

              def result
                success(from: :result)
              end

              def try_result
                success(from: :try_result)
              end
            end
          end

          let(:result) { first_step.success }

          it "returns result" do
            expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
          end

          it "returns result with unchecked status" do
            expect(method_value.has_checked_status?).to eq(false)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
