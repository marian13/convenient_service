# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Middleware, type: :standard do
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
            include ConvenientService::Standard::Config

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
      end

      it "returns service result with step and organizer" do
        expect(step.result).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz).of_step(first_step).of_service(container).of_original_service(first_step)
      end

      context "when `step` result has success status" do
        context "when `step` has no outputs" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, middleware) do |first_step, middleware|
                include ConvenientService::Standard::Config

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware
                  end
                end

                step first_step
              end
            end
          end

          it "returns service result with original data keys" do
            expect(step.result).to be_success.with_data(foo: :foo, bar: :bar, baz: :baz).of_step(first_step).of_service(container)
          end
        end

        context "when `step` has outputs" do
          context "when `step` has one output" do
            context "when step result does NOT have attribute by that output key" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step, middleware) do |first_step, middleware|
                    include ConvenientService::Standard::Config

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware
                      end
                    end

                    step first_step, out: :qux
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Step `#{step.printable_action}` result does NOT return `:qux` data attribute.

                  Maybe there is a typo in `out` definition?

                  Or `success` of `#{step.printable_action}` accepts a wrong key?
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute`" do
                expect { step.result }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute) { step.result } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when step result has attribute by that output key" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step, middleware) do |first_step, middleware|
                    include ConvenientService::Standard::Config

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware
                      end
                    end

                    step first_step, out: :foo
                  end
                end
              end

              it "returns service result only with that output data key" do
                expect(step.result).to be_success.with_data(foo: :foo).of_step(first_step).of_service(container)
              end
            end
          end

          context "when `step` has multiple outputs" do
            context "when step result does NOT have any attribute by those output keys" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step, middleware) do |first_step, middleware|
                    include ConvenientService::Standard::Config

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware
                      end
                    end

                    step first_step, out: [:baz, :qux]
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Step `#{step.printable_action}` result does NOT return `:qux` data attribute.

                  Maybe there is a typo in `out` definition?

                  Or `success` of `#{step.printable_action}` accepts a wrong key?
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute`" do
                expect { step.result }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute) { step.result } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when step result has all attributes by those output keys" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step, middleware) do |first_step, middleware|
                    include ConvenientService::Standard::Config

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware
                      end
                    end

                    step first_step, out: [:foo, :bar]
                  end
                end
              end

              it "returns service result only with those output data keys" do
                expect(step.result).to be_success.with_data(foo: :foo, bar: :bar).of_step(first_step).of_service(container)
              end
            end
          end

          context "when `step` has any output with alias" do
            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(first_step, middleware) do |first_step, middleware|
                  include ConvenientService::Standard::Config

                  self::Step.class_exec(middleware) do |middleware|
                    middlewares :result do
                      observe middleware
                    end
                  end

                  step first_step, out: [{foo: :abc}, :bar]
                end
              end
            end

            it "returns service result only with outputs data keys respecting aliases" do
              expect(step.result).to be_success.with_data(abc: :foo, bar: :bar).of_step(first_step).of_service(container)
            end
          end
        end
      end

      context "when `step` result has failure status" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure(data: {foo: :foo, bar: :bar, baz: :baz})
            end
          end
        end

        it "returns service result with original data keys" do
          expect(step.result).to be_failure.with_data(foo: :foo, bar: :bar, baz: :baz).of_step(first_step).of_service(container)
        end
      end

      context "when `step` result has error status" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error(data: {foo: :foo, bar: :bar, baz: :baz})
            end
          end
        end

        it "returns service result with original data keys" do
          expect(step.result).to be_error.with_data(foo: :foo, bar: :bar, baz: :baz).of_step(first_step).of_service(container)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
