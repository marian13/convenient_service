# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveBeforeStepCallbacks::Middleware, type: :standard do
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
          intended_for :before, scope: :class, entity: :service
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

      let(:method) { wrap_method(service_class, :before, observe_middleware: middleware) }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :before, scope: :class do
              observe middleware
            end
          end
        end
      end

      let(:block) { proc { :first_step } }

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

        it "does NOT add before `:step` callback to service class" do
          method_value

          expect(service_class.callbacks.for([:before, :step])).to be_empty
        end

        it "adds before `:result` callback to service step class" do
          method_value

          ##
          # NOTE: Comprehensive suite context checks whether a proper `block` with `instance_exec` is passed to callback.
          #
          expect(service_class.step_class.callbacks.for([:before, :organizer_result])).not_to be_empty
        end

        it "passes original block source location to before `:result` callback for service step class" do
          method_value

          expect(service_class.step_class.callbacks.for([:before, :organizer_result]).first.source_location).to eq(block.source_location)
        end

        example_group "comprehensive suite" do
          let(:out) { Tempfile.new }
          let(:output) { out.tap(&:rewind).read }

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

            let(:text) do
              <<~TEXT
                first before step
                some instance method
                step :first_step
              TEXT
            end

            before do
              service_class.before(:step) do
                out.puts "first before step"

                some_instance_method
              end
            end

            it "executes service before `:step` callbacks context (step before `:result` callbacks context) in service instance context" do
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

              it "executes service before `:step` callbacks context (step before `:result` callbacks context) in service instance context" do
                service_class.result

                expect(output).to eq(text)
              end
            end
          end

          example_group "method arguments" do
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

            let(:text) do
              <<~TEXT
                first before step
                  args - [:first_step]
                  kwargs.keys - [:in, :out, :strict, :index]
                  block - nil
                step :first_step
              TEXT
            end

            before do
              service_class.before(:step) do |arguments|
                out.puts "first before step"

                out.puts "  args - #{arguments.args.inspect}"
                out.puts "  kwargs.keys - #{arguments.kwargs.keys.inspect}"
                out.puts "  block - #{arguments.block.inspect}"
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
                  first before step
                    args - [:first_step]
                    kwargs.keys - [:in, :out, :strict, :index, :cache]
                    block - nil
                  step :first_step
                TEXT
              end

              it "passes step args, kwargs(except container, organizer) with extra kwargs" do
                service_class.result

                expect(output).to eq(text)
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
                before step 1
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - not_completed
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - first_step_shared_output_value
                step :first_step
                before step 2
                  output first_step_first_output via reader - first_step_first_output_value
                  output second_step_first_output via reader - second_step_first_output_value
                  output third_step_first_output via reader - not_completed
                  output shared_output via reader - second_step_shared_output_value
                step :first_step
              TEXT
            end

            before do
              service_class.before(:step) do |arguments|
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
