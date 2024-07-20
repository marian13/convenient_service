# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveBeforeStepCallbacks::Middleware, type: :standard do
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

      let(:block) { proc { :foo } }

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
          expect(service_class.step_class.callbacks.for([:before, :result])).not_to be_empty
        end

        example_group "comprehensive suite" do
          let(:out) { Tempfile.new }
          let(:output) { out.tap(&:rewind).read }

          example_group "context" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step :foo

                  def foo
                    success.tap { out.puts "step :foo" }
                  end

                  define_method(:out) { out }

                  def some_instance_method
                    out.puts "some instance method"
                  end
                end
              end
            end

            example_group "service before `:step` callbacks context (step before `:result` callbacks context)" do
              let(:text) do
                <<~TEXT
                  first before step
                  some instance method
                  step :foo
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

                      step :foo

                      def foo
                        success.tap { out.puts "step :foo" }
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
          end

          example_group "method arguments" do
            let(:out) { Tempfile.new }
            let(:output) { out.tap(&:rewind).read }

            let(:args) { [:foo] }
            let(:kwargs) { {foo: :bar} }
            let(:block) { proc { :foo } }

            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(out) do |out|
                  include ConvenientService::Standard::Config

                  step_class.class_exec do
                    define_method(:result) { |*args, **kwargs, &block| super() }
                  end

                  step :foo

                  def foo
                    success.tap { out.puts "step :foo" }
                  end

                  define_method(:out) { out }
                end
              end
            end

            example_group "service before `:step` callbacks method arguments (step before `:result` callbacks method arguments)" do
              let(:text) do
                <<~TEXT
                  first before step
                    args - [:foo]
                    kwargs - {:foo=>:bar}
                    block - proc { :foo }
                  step :foo
                TEXT
              end

              before do
                service_class.before(:step) do |arguments|
                  out.puts "first before step"

                  out.puts "  args - #{arguments.args.inspect}"
                  out.puts "  kwargs - #{arguments.kwargs.inspect}"
                  out.puts "  block - proc { #{arguments.block.call.inspect} }"
                end
              end

              it "passes args, kwargs, block as arguments object" do
                service_class.new.steps.first.result(*args, **kwargs, &block)

                expect(output).to eq(text)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
