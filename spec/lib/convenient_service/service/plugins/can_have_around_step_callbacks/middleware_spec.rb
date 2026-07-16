# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveAroundStepCallbacks::Middleware, type: :standard do
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
          intended_for :around, scope: :class, entity: :service
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

      subject(:method_value) { method.call(method_name, &block) }

      let(:method) { wrap_method(service_class, :around, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :around, scope: :class do
              observe middleware
            end
          end
        end
      end

      let(:block) { proc { |chain| chain.yield } }

      context "when callback `method` is NOT `:step`" do
        let(:method_name) { :result }

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(:result, &block)
            .and_return_its_value
        end
      end

      context "when callback `method` is `:step`" do
        let(:method_name) { :step }

        specify do
          expect { method_value }.not_to call_chain_next.on(method)
        end

        it "does NOT add around `:step` callback to service class" do
          method_value

          expect(service_class.callbacks.for([:around, :step])).to be_empty
        end

        it "adds around `:result` callback to service step class" do
          method_value

          ##
          # NOTE: Comprehensive suite context checks whether a proper `block` with `instance_exec` is passed to callback.
          #
          expect(service_class.step_class.callbacks.for([:around, :organizer_result])).not_to be_empty
        end

        it "passes original block source location to around `:result` callback for service step class" do
          method_value

          expect(service_class.step_class.callbacks.for([:around, :organizer_result]).first.source_location).to eq(block.source_location)
        end

        example_group "comprehensive suite" do
          let(:out) { Tempfile.new }
          let(:output) { out.tap(&:rewind).read }

          example_group "first argument" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step :first_step

                  def first_step
                    success.tap { out.puts "step :first_step" }
                  end

                  define_method(:out) { out }
                end
              end
            end

            let(:text) do
              <<~TEXT
                first around before step
                  chain - Proc
                step :first_step
                first around after step
              TEXT
            end

            before do
              service_class.around(:step) do |chain|
                out.puts "first around before step"
                out.puts "  chain - #{chain.class}"

                chain.yield

                out.puts "first around after step"
              end
            end

            it "passes callback chain to after callbacks as first argument" do
              service_class.result

              expect(output).to eq(text)
            end
          end

          example_group "callback `chain.yield` return value" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step :first_step

                  def first_step
                    success.tap { out.puts "step :first_step" }
                  end

                  define_method(:out) { out }
                end
              end
            end

            let(:text) do
              <<~TEXT
                first around before step
                step :first_step
                  step - #{service_class.step_class}
                first around after step
              TEXT
            end

            before do
              service_class.around(:step) do |chain|
                out.puts "first around before step"

                step = chain.yield

                out.puts "  step - #{step.class}"

                out.puts "first around after step"
              end
            end

            it "passes step to after callbacks as first argument" do
              service_class.result

              expect(output).to eq(text)
            end
          end

          example_group "NOT called callback `chain.yield`" do
            context "when around callback does NOT call callback `chain.yield`" do
              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(out) do |out|
                    include ConvenientService::Standard::Config

                    step :first_step

                    def first_step
                      success.tap { out.puts "step :first_step" }
                    end

                    define_method(:out) { out }
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  Around callback chain is NOT continued from `#{callback_block.source_location.join(":")}`.

                  Did you forget to call `chain.yield`? For example:

                  around :result do |chain|
                    # ...
                    chain.yield
                    # ...
                  end
                TEXT
              end

              let(:callback_block) do
                proc do |chain|
                  out.puts "first around before result"

                  out.puts "first around after result"
                end
              end

              before do
                service_class.around(:step, &callback_block)
              end

              it "raises `ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued`" do
                expect { service_class.result }
                  .to raise_error(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued) { service_class.result } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end
          end

          example_group "context" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step :first_step

                  def first_step
                    success.tap { out.puts "step :first_step" }
                  end

                  define_method(:out) { out }

                  def some_instance_method
                    out.puts "some instance method"
                  end
                end
              end
            end

            example_group "service around `:step` callbacks context (step around `:result` callbacks context)" do
              let(:text) do
                <<~TEXT
                  first around before step
                  some instance method
                  step :first_step
                  first around after step
                TEXT
              end

              before do
                service_class.around(:step) do |chain|
                  out.puts "first around before step"

                  some_instance_method

                  chain.yield

                  out.puts "first around after step"
                end
              end

              it "executes service around `:step` callbacks context (step around `:result` callbacks context) in service instance context" do
                service_class.result

                expect(output).to eq(text)
              end

              context "when callback `block` uses service private instance methods" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(out) do |out|
                      include ConvenientService::Standard::Config

                      step :first_step

                      def first_step
                        success.tap { out.puts "step :first_step" }
                      end

                      define_method(:out) { out }

                      private

                      def some_instance_method
                        out.puts "some instance method"
                      end
                    end
                  end
                end

                it "executes service around `:step` callbacks context (step around `:result` callbacks context) in service instance context" do
                  service_class.result

                  expect(output).to eq(text)
                end
              end
            end
          end

          example_group "method arguments" do
            let(:args) { [:first_step] }
            let(:kwargs) { {first_step: :first_step_first_input} }
            let(:block) { proc { :first_step } }

            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step :first_step,
                    in: :first_step_first_input,
                    out: :first_step_first_output

                  def first_step
                    success(first_step_first_output: "first_step_first_output_value").tap { out.puts "step :first_step" }
                  end

                  def first_step_first_input
                    "first_step_first_input_value"
                  end

                  define_method(:out) { out }
                end
              end
            end

            example_group "service around `:step` callbacks method arguments (step around `:result` callbacks method arguments)" do
              let(:text) do
                <<~TEXT
                  first around before step
                    args - [:first_step]
                    kwargs.keys - [:in, :out, :strict, :index]
                    block - nil
                  step :first_step
                  first around after step
                TEXT
              end

              before do
                service_class.around(:step) do |chain, arguments|
                  out.puts "first around before step"

                  out.puts "  args - #{arguments.args.inspect}"
                  out.puts "  kwargs.keys - #{arguments.kwargs.keys.inspect}"
                  out.puts "  block - #{arguments.block.inspect}"

                  chain.yield

                  out.puts "first around after step"
                end
              end

              it "passes step args, kwargs(except container, organizer)" do
                service_class.result

                expect(output).to eq(text)
              end

              context "when step has extra kwargs" do
                let(:service_class) do
                  Class.new.tap do |klass|
                    klass.class_exec(out) do |out|
                      include ConvenientService::Standard::Config

                      step :first_step,
                        in: :first_step_first_input,
                        out: :first_step_first_output,
                        cache: false

                      def first_step
                        success(first_step_first_output: "first_step_first_output_value").tap { out.puts "step :first_step" }
                      end

                      def first_step_first_input
                        "first_step_first_input_value"
                      end

                      define_method(:out) { out }
                    end
                  end
                end

                let(:text) do
                  <<~TEXT
                    first around before step
                      args - [:first_step]
                      kwargs.keys - [:in, :out, :strict, :index, :cache]
                      block - nil
                    step :first_step
                    first around after step
                  TEXT
                end

                it "passes step args, kwargs(except container, organizer) with extra kwargs" do
                  service_class.result

                  expect(output).to eq(text)
                end
              end
            end
          end

          example_group "step/organizer data access" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step :first_step,
                    in: :first_step_first_input,
                    out: [
                      :first_step_first_output,
                      {shared_output: -> { "first_step_shared_output_value" }}
                    ]

                  step :second_step,
                    in: :second_step_first_input,
                    out: [
                      :second_step_first_output,
                      {shared_output: -> { "second_step_shared_output_value" }}
                    ]

                  step :third_step,
                    in: :third_step_first_input,
                    out: [
                      :third_step_first_output,
                      {shared_output: -> { "third_step_shared_output_value" }}
                    ]

                  def first_step
                    success(first_step_first_output: "first_step_first_output_value").tap { out.puts "step :first_step" }
                  end

                  def first_step_first_input
                    "first_step_first_input_value"
                  end

                  def second_step
                    success(second_step_first_output: "second_step_first_output_value").tap { out.puts "step :first_step" }
                  end

                  def second_step_first_input
                    "second_step_first_input_value"
                  end

                  def third_step
                    success(third_step_first_output: "third_step_first_output_value").tap { out.puts "step :first_step" }
                  end

                  def third_step_first_input
                    "third_step_first_input_value"
                  end

                  define_method(:out) { out }
                end
              end
            end

            let(:text) do
              <<~TEXT
                before step 0
                  output first_step_first_output via reader - not_completed
                  output second_step_first_output via reader - not_completed
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - not_completed
                step :first_step
                after step 0
                  outputs via step.result - first_step_first_output_value,first_step_shared_output_value
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - not_completed
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - first_step_shared_output_value
                before step 1
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - not_completed
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - first_step_shared_output_value
                step :first_step
                after step 1
                  outputs via step.result - second_step_first_output_value,second_step_shared_output_value
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - second_step_first_output_value
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - second_step_shared_output_value
                before step 2
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - second_step_first_output_value
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - second_step_shared_output_value
                step :first_step
                after step 2
                  outputs via step.result - third_step_first_output_value,third_step_shared_output_value
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - second_step_first_output_value
                  output third_step_first_output via reader - third_step_first_output_value
                  output shared_output via reader - third_step_shared_output_value
              TEXT
            end

            before do
              service_class.around(:step) do |chain, arguments|
                to_value = ->(&block) do
                  block.call
                rescue ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted
                  "not_completed"
                end

                out.puts "before step #{arguments.kwargs[:index]}"

                case arguments
                in {kwargs: {index: 0}}
                  out.puts "  output first_step_first_output via reader - #{to_value.call { first_step_first_output }}"
                  out.puts "  output second_step_first_output via reader - #{to_value.call { second_step_first_output }}"
                  out.puts "  output third_step_first_output via reader - #{to_value.call { third_step_first_output }}"
                  out.puts "  output shared_output via reader - #{to_value.call { shared_output }}"
                in {kwargs: {index: 1}}
                  out.puts "  output first_step_first_output via reader - #{first_step_first_output}"
                  out.puts "  output second_step_first_output via reader - #{to_value.call { second_step_first_output }}"
                  out.puts "  output third_step_first_output via reader - #{to_value.call { third_step_first_output }}"
                  out.puts "  output shared_output via reader - #{shared_output}"
                in {kwargs: {index: 2}}
                  out.puts "  output first_step_first_output via reader - #{first_step_first_output}"
                  out.puts "  output second_step_first_output via reader - #{second_step_first_output}"
                  out.puts "  output third_step_first_output via reader - #{to_value.call { third_step_first_output }}"
                  out.puts "  output shared_output via reader - #{shared_output}"
                else
                  raise
                end

                step = chain.yield

                out.puts "after step #{step.index}"

                case step.index
                when 0
                  out.puts "  outputs via step.result - #{step.result.call.values.join(",")}"
                  out.puts "  output first_step_first_output via reader - #{first_step_first_output}"
                  out.puts "  output second_step_first_output via reader - #{to_value.call { second_step_first_output }}"
                  out.puts "  output third_step_first_output via reader - #{to_value.call { third_step_first_output }}"
                  out.puts "  output shared_output via reader - #{shared_output}"
                when 1
                  out.puts "  outputs via step.result - #{step.result.call.values.join(",")}"
                  out.puts "  output first_step_first_output via reader - #{first_step_first_output}"
                  out.puts "  output second_step_first_output via reader - #{second_step_first_output}"
                  out.puts "  output third_step_first_output via reader - #{to_value.call { third_step_first_output }}"
                  out.puts "  output shared_output via reader - #{shared_output}"
                when 2
                  out.puts "  outputs via step.result - #{step.result.call.values.join(",")}"
                  out.puts "  output first_step_first_output via reader - #{first_step_first_output}"
                  out.puts "  output second_step_first_output via reader - #{second_step_first_output}"
                  out.puts "  output third_step_first_output via reader - #{third_step_first_output}"
                  out.puts "  output shared_output via reader - #{shared_output}"
                else
                  raise
                end
              end
            end

            it "has access to step/organizer data" do
              service_class.result

              expect(output).to eq(text)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
