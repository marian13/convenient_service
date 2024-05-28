# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :result, observe_middleware: middleware.with(fallback_true_status: :failure)) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(first_step, middleware) do |first_step, middleware|
            include ConvenientService::Service::Configs::Standard

            self::Step.class_exec(middleware) do |middleware|
              middlewares :result do
                observe middleware.with(fallback_true_status: :failure)
              end
            end

            step first_step
          end
        end
      end

      let(:first_step) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def result
            success(from: :result)
          end

          def fallback_result
            success(from: :fallback_result)
          end
        end
      end

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .without_arguments
      end

      context "when step is NOT fallback step" do
        context "when step has NO fallback option" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, middleware) do |first_step, middleware|
                include ConvenientService::Service::Configs::Standard

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware.with(fallback_true_status: :failure)
                  end
                end

                step first_step
              end
            end
          end

          it "returns result" do
            expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
          end
        end

        context "when step has fallback option set to `false`" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, middleware) do |first_step, middleware|
                include ConvenientService::Service::Configs::Standard

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware.with(fallback_true_status: :failure)
                  end
                end

                step first_step, fallback: false
              end
            end
          end

          it "returns result" do
            expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
          end
        end
      end

      context "when step is fallback step" do
        context "when step fallback option is set to `true`" do
          ##
          # NOTE: It defaults to `:failure`.
          #
          context "when middleware `fallback_true_status` kwarg is NOT passed" do
            let(:method) { wrap_method(step, :result, observe_middleware: middleware) }

            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(first_step, middleware) do |first_step, middleware|
                  include ConvenientService::Service::Configs::Standard

                  self::Step.class_exec(middleware) do |middleware|
                    middlewares :result do
                      replace middleware.with(fallback_true_status: :failure), middleware

                      observe middleware
                    end
                  end

                  step first_step, fallback: true
                end
              end
            end

            context "when result has `:failure` status" do
              context "when step service does NOT override neither `fallback_failure_result` nor `fallback_result` methods" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Neither `fallback_failure_result` nor `fallback_result` methods of `#{first_step}` are overridden, but the step is marked to be fallbacked.

                    Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{container}`.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when step service overrides `fallback_failure_result` method" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end

                    def fallback_failure_result
                      success(from: :fallback_failure_result)
                    end
                  end
                end

                it "returns fallback failure result" do
                  expect(method_value).to be_success.with_data(from: :fallback_failure_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step service overrides `fallback_result` method" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end

                    def fallback_result
                      success(from: :fallback_result)
                    end
                  end
                end

                it "returns fallback result" do
                  expect(method_value).to be_success.with_data(from: :fallback_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step service overrides both `fallback_failure_result` and `fallback_result` methods" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end

                    def fallback_failure_result
                      success(from: :fallback_failure_result)
                    end

                    def fallback_result
                      success(from: :fallback_result)
                    end
                  end
                end

                it "returns fallback failure result" do
                  expect(method_value).to be_success.with_data(from: :fallback_failure_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step is method step" do
                let(:container) do
                  Class.new.tap do |klass|
                    klass.class_exec(first_step, middleware) do |first_step, middleware|
                      include ConvenientService::Service::Configs::Standard

                      self::Step.class_exec(middleware) do |middleware|
                        middlewares :result do
                          replace middleware.with(fallback_true_status: :failure), middleware

                          observe middleware
                        end
                      end

                      step :foo, fallback: true

                      def foo
                        failure("from method step")
                      end
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Method step can NOT have fallback.

                    Either remove `fallback` option from step `:foo` in `#{container}` or consider to refactor it into a service step.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback)
                    .with_message(exception_message)
                end
              end
            end

            context "when result has `:error` status" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    error("from result")
                  end

                  def fallback_failure_result
                    success(from: :fallback_failure_result)
                  end
                end
              end

              it "returns result" do
                expect(method_value).to be_error.with_message("from result").of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when result has `:success` status" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    success(from: :result)
                  end

                  def fallback_failure_result
                    success(from: :fallback_failure_result)
                  end
                end
              end

              it "returns result" do
                expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end
          end

          context "when middleware `fallback_true_status` kwarg is `:failure`" do
            let(:method) { wrap_method(step, :result, observe_middleware: middleware.with(fallback_true_status: :failure)) }

            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(first_step, middleware) do |first_step, middleware|
                  include ConvenientService::Service::Configs::Standard

                  self::Step.class_exec(middleware) do |middleware|
                    middlewares :result do
                      observe middleware.with(fallback_true_status: :failure)
                    end
                  end

                  step first_step, fallback: true
                end
              end
            end

            context "when result has `:failure` status" do
              context "when step service does NOT override neither `fallback_failure_result` nor `fallback_result` methods" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Neither `fallback_failure_result` nor `fallback_result` methods of `#{first_step}` are overridden, but the step is marked to be fallbacked.

                    Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{container}`.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when step service overrides `fallback_failure_result` method" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end

                    def fallback_failure_result
                      success(from: :fallback_failure_result)
                    end
                  end
                end

                it "returns fallback failure result" do
                  expect(method_value).to be_success.with_data(from: :fallback_failure_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step service overrides `fallback_result` method" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end

                    def fallback_result
                      success(from: :fallback_result)
                    end
                  end
                end

                it "returns fallback result" do
                  expect(method_value).to be_success.with_data(from: :fallback_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step service overrides both `fallback_failure_result` and `fallback_result` methods" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      failure("from result")
                    end

                    def fallback_failure_result
                      success(from: :fallback_failure_result)
                    end

                    def fallback_result
                      success(from: :fallback_result)
                    end
                  end
                end

                it "returns fallback failure result" do
                  expect(method_value).to be_success.with_data(from: :fallback_failure_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step is method step" do
                let(:container) do
                  Class.new.tap do |klass|
                    klass.class_exec(first_step, middleware) do |first_step, middleware|
                      include ConvenientService::Service::Configs::Standard

                      self::Step.class_exec(middleware) do |middleware|
                        middlewares :result do
                          observe middleware.with(fallback_true_status: :failure)
                        end
                      end

                      step :foo, fallback: true

                      def foo
                        failure("from method step")
                      end
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Method step can NOT have fallback.

                    Either remove `fallback` option from step `:foo` in `#{container}` or consider to refactor it into a service step.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback)
                    .with_message(exception_message)
                end
              end
            end

            context "when result has `:error` status" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    error("from result")
                  end

                  def fallback_failure_result
                    success(from: :fallback_failure_result)
                  end
                end
              end

              it "returns result" do
                expect(method_value).to be_error.with_message("from result").of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when result has `:success` status" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    success(from: :result)
                  end

                  def fallback_failure_result
                    success(from: :fallback_failure_result)
                  end
                end
              end

              it "returns result" do
                expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end
          end

          context "when `fallback_true_status` is `:error`" do
            let(:method) { wrap_method(step, :result, observe_middleware: middleware.with(fallback_true_status: :error)) }

            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(first_step, middleware) do |first_step, middleware|
                  include ConvenientService::Service::Configs::Standard

                  self::Step.class_exec(middleware) do |middleware|
                    middlewares :result do
                      replace middleware.with(fallback_true_status: :failure), middleware.with(fallback_true_status: :error)

                      observe middleware.with(fallback_true_status: :error)
                    end
                  end

                  step first_step, fallback: true
                end
              end
            end

            context "when result has `:failure` status" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure("from result")
                  end

                  def fallback_error_result
                    success(from: :fallback_error_result)
                  end
                end
              end

              it "returns result" do
                expect(method_value).to be_failure.with_message("from result").of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when result has `:error` status" do
              context "when step service does NOT override neither `fallback_error_result` nor `fallback_result` methods" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      error("from result")
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Neither `fallback_error_result` nor `fallback_result` methods of `#{first_step}` are overridden, but the step is marked to be fallbacked.

                    Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{container}`.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                    .with_message(exception_message)
                end

                specify do
                  expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { method_value } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end

              context "when step service overrides `fallback_error_result` method" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      error("from result")
                    end

                    def fallback_error_result
                      success(from: :fallback_error_result)
                    end
                  end
                end

                it "returns fallback error result" do
                  expect(method_value).to be_success.with_data(from: :fallback_error_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step service overrides `fallback_result` method" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      error("from result")
                    end

                    def fallback_result
                      success(from: :fallback_result)
                    end
                  end
                end

                it "returns fallback result" do
                  expect(method_value).to be_success.with_data(from: :fallback_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step service overrides both `fallback_error_result` and `fallback_result` methods" do
                let(:first_step) do
                  Class.new do
                    include ConvenientService::Service::Configs::Standard

                    def result
                      error("from result")
                    end

                    def fallback_error_result
                      success(from: :fallback_error_result)
                    end

                    def fallback_result
                      success(from: :fallback_result)
                    end
                  end
                end

                it "returns fallback error result" do
                  expect(method_value).to be_success.with_data(from: :fallback_error_result).of_step(first_step)
                end

                it "returns result with NOT checked status" do
                  expect(method_value.checked?).to eq(false)
                end
              end

              context "when step is method step" do
                let(:container) do
                  Class.new.tap do |klass|
                    klass.class_exec(first_step, middleware) do |first_step, middleware|
                      include ConvenientService::Service::Configs::Standard

                      self::Step.class_exec(middleware) do |middleware|
                        middlewares :result do
                          replace middleware.with(fallback_true_status: :failure), middleware.with(fallback_true_status: :error)

                          observe middleware.with(fallback_true_status: :error)
                        end
                      end

                      step :foo, fallback: true

                      def foo
                        error("from method step")
                      end
                    end
                  end
                end

                let(:exception_message) do
                  <<~TEXT
                    Method step can NOT have fallback.

                    Either remove `fallback` option from step `:foo` in `#{container}` or consider to refactor it into a service step.
                  TEXT
                end

                it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback`" do
                  expect { method_value }
                    .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback)
                    .with_message(exception_message)
                end
              end
            end

            context "when result has `:success` status" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    success(from: :result)
                  end

                  def fallback_error_result
                    success(from: :fallback_error_result)
                  end
                end
              end

              let(:result) { first_step.success }

              it "returns result" do
                expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end
          end
        end

        context "when step fallback option is set to `[:failure]`" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, middleware) do |first_step, middleware|
                include ConvenientService::Service::Configs::Standard

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware.with(fallback_true_status: :failure)
                  end
                end

                step first_step, fallback: [:failure]
              end
            end
          end

          context "when result has `:failure` status" do
            context "when step service does NOT override neither `fallback_failure_result` nor `fallback_result` methods" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure("from result")
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Neither `fallback_failure_result` nor `fallback_result` methods of `#{first_step}` are overridden, but the step is marked to be fallbacked.

                  Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{container}`.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { method_value } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when step service overrides `fallback_failure_result` method" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure("from result")
                  end

                  def fallback_failure_result
                    success(from: :fallback_failure_result)
                  end
                end
              end

              it "returns fallback failure result" do
                expect(method_value).to be_success.with_data(from: :fallback_failure_result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when step service overrides `fallback_result` method" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure("from result")
                  end

                  def fallback_result
                    success(from: :fallback_result)
                  end
                end
              end

              it "returns fallback result" do
                expect(method_value).to be_success.with_data(from: :fallback_result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when step service overrides both `fallback_failure_result` and `fallback_result` methods" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    failure("from result")
                  end

                  def fallback_failure_result
                    success(from: :fallback_failure_result)
                  end

                  def fallback_result
                    success(from: :fallback_result)
                  end
                end
              end

              it "returns fallback failure result" do
                expect(method_value).to be_success.with_data(from: :fallback_failure_result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when step is method step" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step, middleware) do |first_step, middleware|
                    include ConvenientService::Service::Configs::Standard

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware.with(fallback_true_status: :failure)
                      end
                    end

                    step :foo, fallback: [:failure]

                    def foo
                      failure("from method step")
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Method step can NOT have fallback.

                  Either remove `fallback` option from step `:foo` in `#{container}` or consider to refactor it into a service step.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback)
                  .with_message(exception_message)
              end
            end
          end

          context "when result has `:error` status" do
            let(:first_step) do
              Class.new do
                include ConvenientService::Service::Configs::Standard

                def result
                  error("from result")
                end

                def fallback_failure_result
                  success(from: :fallback_failure_result)
                end
              end
            end

            it "returns result" do
              expect(method_value).to be_error.with_message("from result").of_step(first_step)
            end

            it "returns result with NOT checked status" do
              expect(method_value.checked?).to eq(false)
            end
          end

          context "when result has `:success` status" do
            let(:first_step) do
              Class.new do
                include ConvenientService::Service::Configs::Standard

                def result
                  success(from: :result)
                end

                def fallback_failure_result
                  success(from: :fallback_failure_result)
                end
              end
            end

            it "returns result" do
              expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
            end

            it "returns result with NOT checked status" do
              expect(method_value.checked?).to eq(false)
            end
          end
        end

        context "when step fallback option is set to `[:error]`" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, middleware) do |first_step, middleware|
                include ConvenientService::Service::Configs::Standard

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware.with(fallback_true_status: :failure)
                  end
                end

                step first_step, fallback: [:error]
              end
            end
          end

          context "when result has `:failure` status" do
            let(:first_step) do
              Class.new do
                include ConvenientService::Service::Configs::Standard

                def result
                  failure("from result")
                end

                def fallback_error_result
                  success(from: :fallback_error_result)
                end
              end
            end

            it "returns result" do
              expect(method_value).to be_failure.with_message("from result").of_step(first_step)
            end

            it "returns result with NOT checked status" do
              expect(method_value.checked?).to eq(false)
            end
          end

          context "when result has `:error` status" do
            context "when step service does NOT override neither `fallback_error_result` nor `fallback_result` methods" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    error("from result")
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Neither `fallback_error_result` nor `fallback_result` methods of `#{first_step}` are overridden, but the step is marked to be fallbacked.

                  Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{container}`.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden) { method_value } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when step service overrides `fallback_error_result` method" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    error("from result")
                  end

                  def fallback_error_result
                    success(from: :fallback_error_result)
                  end
                end
              end

              it "returns fallback error result" do
                expect(method_value).to be_success.with_data(from: :fallback_error_result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when step service overrides `fallback_result` method" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    error("from result")
                  end

                  def fallback_result
                    success(from: :fallback_result)
                  end
                end
              end

              it "returns fallback result" do
                expect(method_value).to be_success.with_data(from: :fallback_result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when step service overrides both `fallback_error_result` and `fallback_result` methods" do
              let(:first_step) do
                Class.new do
                  include ConvenientService::Service::Configs::Standard

                  def result
                    error("from result")
                  end

                  def fallback_error_result
                    success(from: :fallback_error_result)
                  end

                  def fallback_result
                    success(from: :fallback_result)
                  end
                end
              end

              it "returns fallback error result" do
                expect(method_value).to be_success.with_data(from: :fallback_error_result).of_step(first_step)
              end

              it "returns result with NOT checked status" do
                expect(method_value.checked?).to eq(false)
              end
            end

            context "when step is method step" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step, middleware) do |first_step, middleware|
                    include ConvenientService::Service::Configs::Standard

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware.with(fallback_true_status: :failure)
                      end
                    end

                    step :foo, fallback: [:error]

                    def foo
                      error("from method step")
                    end
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Method step can NOT have fallback.

                  Either remove `fallback` option from step `:foo` in `#{container}` or consider to refactor it into a service step.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback`" do
                expect { method_value }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback)
                  .with_message(exception_message)
              end
            end
          end

          context "when result has `:success` status" do
            let(:first_step) do
              Class.new do
                include ConvenientService::Service::Configs::Standard

                def result
                  success(from: :result)
                end

                def fallback_error_result
                  success(from: :fallback_error_result)
                end
              end
            end

            let(:result) { first_step.success }

            it "returns result" do
              expect(method_value).to be_success.with_data(from: :result).of_step(first_step)
            end

            it "returns result with NOT checked status" do
              expect(method_value.checked?).to eq(false)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
