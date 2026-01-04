# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Commands::CalculateMethodResult, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:middleware) { described_class }

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(step: step) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      context "when step is NOT method step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Step `#{step.printable_action}` is NOT a method step.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::StepIsNotMethodStep`" do
          expect { command_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::StepIsNotMethodStep)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::StepIsNotMethodStep) { command_result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when step is method step" do
        context "when step is any method step" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo

              def foo
                success
              end
            end
          end

          context "when `organizer` does NOT have own `:foo` method" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
              end
            end

            let(:exception_message) do
              <<~TEXT
                Service `#{container}` tries to use `:foo` method in a step, but it is NOT defined.

                Did you forget to define it?
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::MethodForStepIsNotDefined`" do
              expect { command_result }
                .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::MethodForStepIsNotDefined)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::MethodForStepIsNotDefined) { command_result } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `organizer` has own `:foo` method" do
            let(:prepend_module) do
              Module.new.tap do |mod|
                def foo
                  failure
                end
              end
            end

            context "when that own `:foo` method does NOT accept any arguments" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(prepend_module) do |prepend_module|
                    include ConvenientService::Standard::Config

                    step :foo

                    def foo
                      success
                    end

                    ##
                    # NOTE: Used to confirm that own is called, not prepended method.
                    #
                    prepend prepend_module
                  end
                end
              end

              it "calls that own method without inputs" do
                ##
                # NOTE: Own method returns `success`, while prepended returns `failure`.
                # See `organizer_service_class` definition above.
                #
                expect(command_result).to be_success
              end

              specify do
                expect { command_result }
                  .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                  .with_arguments(step.organizer.class, step.method, private: true)
              end
            end

            context "when that own `:foo` method accepts args" do
              context "when that own `:foo` method accepts some required arg" do
                context "when inputs does NOT have that required arg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo

                        def foo(required_arg)
                          success(data: {required_arg: required_arg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  if ConvenientService::Dependencies.ruby.version >= 3.0
                    it "raises `ArgumentError`" do
                      expect { command_result }.to raise_error(ArgumentError)
                    end

                    specify do
                      expect { ignoring_exception(ArgumentError) { command_result } }
                        .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                        .with_arguments(step.organizer.class, step.method, private: true)
                    end
                  else
                    ##
                    # HACK: Ruby 2.7 `(*args, **kwargs)` unexpected behaviour.
                    #
                    it "suprisingly calls that own method with that required arg" do
                      ##
                      # NOTE: Own method returns `success`, while prepended returns `failure`.
                      # See `organizer_service_class` definition above.
                      #
                      expect(command_result).to be_success.with_data(required_arg: {})
                    end
                  end
                end

                context "when inputs have that required arg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo,
                          in: {0 => -> { :required_arg_value }}

                        def foo(required_arg)
                          success(data: {required_arg: required_arg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with that required arg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(required_arg: :required_arg_value)
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:foo` method accepts some optional args" do
                context "when inputs does NOT have that optional arg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo

                        def foo(optional_arg = :optional_arg_default_value)
                          success(data: {optional_arg: optional_arg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method ignoring that optional arg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(optional_arg: :optional_arg_default_value)
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that optional arg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo,
                          in: {0 => -> { :optional_arg_value }}

                        def foo(optional_arg = :optional_arg_default_value)
                          success(data: {optional_arg: optional_arg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with that optional arg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(optional_arg: :optional_arg_value)
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:foo` method accepts rest args" do
                context "when inputs does NOT have any arg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo

                        def foo(*args)
                          success(data: {args: args})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with empty kwargs" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(args: [])
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have any extra arg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo,
                          in: [
                            {0 => -> { :extra_arg_value }}
                          ]

                        def foo(*args)
                          success(data: {args: args})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with that optional kwarg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(args: [:extra_arg_value])
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end
            end

            context "when that own `:foo` method accepts kwargs" do
              context "when that own `:foo` method accepts some required kwargs" do
                context "when inputs does NOT have that required kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo

                        def foo(required_kwarg:)
                          success(data: {required_kwarg: required_kwarg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "raises `ArgumentError`" do
                    expect { command_result }.to raise_error(ArgumentError)
                  end

                  specify do
                    expect { ignoring_exception(ArgumentError) { command_result } }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that required kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo,
                          in: {required_kwarg: -> { :required_kwarg_value }}

                        def foo(required_kwarg:)
                          success(data: {required_kwarg: required_kwarg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with that required kwarg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(required_kwarg: :required_kwarg_value)
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:foo` method accepts some optional kwargs" do
                context "when inputs does NOT have that optional kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo

                        def foo(optional_kwarg: :optional_kwarg_default_value)
                          success(data: {optional_kwarg: optional_kwarg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method ignoring that optional kwarg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(optional_kwarg: :optional_kwarg_default_value)
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that optional kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo,
                          in: {optional_kwarg: -> { :optional_kwarg_value }}

                        def foo(optional_kwarg: :optional_kwarg_default_value)
                          success(data: {optional_kwarg: optional_kwarg})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with that optional kwarg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(optional_kwarg: :optional_kwarg_value)
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:foo` method accepts rest kwargs" do
                context "when inputs does NOT have any kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo

                        def foo(**kwargs)
                          success(data: {kwargs: kwargs})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with empty kwargs" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(kwargs: {})
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have any extra kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module) do |prepend_module|
                        include ConvenientService::Standard::Config

                        step :foo,
                          in: {extra_kwarg: -> { :extra_kwarg_value }}

                        def foo(**kwargs)
                          success(data: {kwargs: kwargs})
                        end

                        ##
                        # NOTE: Used to confirm that own is called, not prepended method.
                        #
                        prepend prepend_module
                      end
                    end
                  end

                  it "calls that own method with that optional kwarg" do
                    ##
                    # NOTE: Own method returns `success`, while prepended returns `failure`.
                    # See `organizer_service_class` definition above.
                    #
                    expect(command_result).to be_success.with_data(kwargs: {extra_kwarg: :extra_kwarg_value})
                  end

                  specify do
                    expect { command_result }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end
            end

            context "when that own `:foo` method accepts block" do
              context "when inputs does NOT have that block" do
                let(:container) do
                  Class.new.tap do |klass|
                    klass.class_exec(prepend_module) do |prepend_module|
                      include ConvenientService::Standard::Config

                      step :foo

                      def foo(&block)
                        success(data: {block: block})
                      end

                      ##
                      # NOTE: Used to confirm that own is called, not prepended method.
                      #
                      prepend prepend_module
                    end
                  end
                end

                it "calls that own method ignoring that optional kwarg" do
                  ##
                  # NOTE: Own method returns `success`, while prepended returns `failure`.
                  # See `organizer_service_class` definition above.
                  #
                  expect(command_result).to be_success.with_data(block: nil)
                end

                specify do
                  expect { command_result }
                    .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                    .with_arguments(step.organizer.class, step.method, private: true)
                end
              end

              context "when inputs have that block" do
                let(:some_block) { proc { :foo } }

                let(:container) do
                  Class.new.tap do |klass|
                    klass.class_exec(some_block, prepend_module) do |some_block, prepend_module|
                      include ConvenientService::Standard::Config

                      step :foo,
                        in: {block => -> { some_block }}

                      def foo(&block)
                        success(data: {block: block.source_location})
                      end

                      define_method(:some_block) { some_block }

                      ##
                      # NOTE: Used to confirm that own is called, not prepended method.
                      #
                      prepend prepend_module
                    end
                  end
                end

                it "calls that own method with that optional kwarg" do
                  ##
                  # NOTE: Own method returns `success`, while prepended returns `failure`.
                  # See `organizer_service_class` definition above.
                  #
                  expect(command_result).to be_success.with_data(block: some_block.source_location)
                end

                specify do
                  expect { command_result }
                    .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                    .with_arguments(step.organizer.class, step.method, private: true)
                end
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
