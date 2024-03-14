# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBeExecuted::Middleware do
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
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :result, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      context "when step is NOT method step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, middleware) do |first_step, middleware|
              include ConvenientService::Service::Configs::Essential

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
            include ConvenientService::Service::Configs::Essential

            def result
              success
            end
          end
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
              .without_arguments
              .and_return { |chain_value| chain_value.copy(overrides: {kwargs: {step: step, service: organizer}}) }
        end

        it "return method step result" do
          expect(method_value).to be_success.without_data.of_step(first_step).of_service(container)
        end
      end

      context "when step is method step" do
        context "when step is any method step" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Service::Configs::Essential

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware
                  end
                end

                step :foo

                def foo
                  success
                end
              end
            end
          end

          specify do
            expect { method_value }.not_to call_chain_next.on(method)
          end

          context "when `organizer` does NOT have own `:foo` method" do
            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Service::Configs::Essential

                  self::Step.class_exec(middleware) do |middleware|
                    middlewares :result do
                      observe middleware
                    end
                  end

                  step :foo
                end
              end
            end

            let(:exception_message) do
              <<~TEXT
                Service `#{container}` tries to use `:foo` method in a step, but it is NOT defined.

                Did you forget to define it?
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined`" do
              expect { method_value }
                .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined) { method_value } }
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

            context "when that own `:foo` method does NOT accept any kwargs" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                    include ConvenientService::Service::Configs::Essential

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware
                      end
                    end

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
                expect(method_value).to be_success
              end

              specify do
                expect { method_value }
                  .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                  .with_arguments(step.organizer.class, step.method, private: true)
              end
            end

            context "when that own `:foo` method accepts kwargs" do
              context "when that own `:foo` method accepts some required kwargs" do
                context "when inputs does NOT have that required kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

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
                    expect { method_value }.to raise_error(ArgumentError)
                  end

                  specify do
                    expect { ignoring_exception(ArgumentError) { method_value } }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that required kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

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
                    expect(method_value).to be_success.with_data(required_kwarg: :required_kwarg_value)
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:foo` method accepts some optional kwargs" do
                context "when inputs does NOT have that optional kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

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
                    expect(method_value).to be_success.with_data(optional_kwarg: :optional_kwarg_default_value)
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that optional kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

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
                    expect(method_value).to be_success.with_data(optional_kwarg: :optional_kwarg_value)
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:foo` method accepts rest kwargs" do
                context "when inputs does NOT have any kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

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
                    expect(method_value).to be_success.with_data(kwargs: {})
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have any extra kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

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
                    expect(method_value).to be_success.with_data(kwargs: {extra_kwarg: :extra_kwarg_value})
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end
            end
          end
        end

        context "when step is `:result` step" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Service::Configs::Essential

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :result do
                    observe middleware
                  end
                end

                step :result

                def result
                  success
                end
              end
            end
          end

          specify do
            expect { method_value }.not_to call_chain_next.on(method)
          end

          context "when `organizer` has own `:result` method" do
            let(:prepend_module) do
              Module.new.tap do |mod|
                def result
                  failure
                end
              end
            end

            context "when that own `:result` method does NOT accept any kwargs" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                    include ConvenientService::Service::Configs::Essential

                    self::Step.class_exec(middleware) do |middleware|
                      middlewares :result do
                        observe middleware
                      end
                    end

                    step :result

                    def result
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
                expect(method_value).to be_success
              end

              specify do
                expect { method_value }
                  .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                  .with_arguments(step.organizer.class, step.method, private: true)
              end
            end

            context "when that own `:result` method accepts kwargs" do
              context "when that own `:result` method accepts some required kwargs" do
                context "when inputs does NOT have that required kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

                        step :result

                        def result(required_kwarg:)
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
                    expect { method_value }.to raise_error(ArgumentError)
                  end

                  specify do
                    expect { ignoring_exception(ArgumentError) { method_value } }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that required kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

                        step :result,
                          in: {required_kwarg: -> { :required_kwarg_value }}

                        def result(required_kwarg:)
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
                    expect(method_value).to be_success.with_data(required_kwarg: :required_kwarg_value)
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:result` method accepts some optional kwargs" do
                context "when inputs does NOT have that optional kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

                        step :result

                        def result(optional_kwarg: :optional_kwarg_default_value)
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
                    expect(method_value).to be_success.with_data(optional_kwarg: :optional_kwarg_default_value)
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have that optional kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

                        step :result,
                          in: {optional_kwarg: -> { :optional_kwarg_value }}

                        def result(optional_kwarg: :optional_kwarg_default_value)
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
                    expect(method_value).to be_success.with_data(optional_kwarg: :optional_kwarg_value)
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end
              end

              context "when that own `:result` method accepts rest kwargs" do
                context "when inputs does NOT have any kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

                        step :result

                        def result(**kwargs)
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
                    expect(method_value).to be_success.with_data(kwargs: {})
                  end

                  specify do
                    expect { method_value }
                      .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
                      .with_arguments(step.organizer.class, step.method, private: true)
                  end
                end

                context "when inputs have any extra kwarg" do
                  let(:container) do
                    Class.new.tap do |klass|
                      klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                        include ConvenientService::Service::Configs::Essential

                        self::Step.class_exec(middleware) do |middleware|
                          middlewares :result do
                            observe middleware
                          end
                        end

                        step :result,
                          in: {extra_kwarg: -> { :extra_kwarg_value }}

                        def result(**kwargs)
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
                    expect(method_value).to be_success.with_data(kwargs: {extra_kwarg: :extra_kwarg_value})
                  end

                  specify do
                    expect { method_value }
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
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
