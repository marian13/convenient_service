# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Essential
      include ConvenientService::Service::Configs::Inspect
    end
  end

  let(:service_instance) { service_class.new }

  let(:step) { first_step }

  let(:first_step) { service_class.step_class.new(*args, **kwargs.merge(index: 0)) }
  let(:second_step) { service_class.step_class.new(*args, **kwargs.merge(index: 1)) }
  let(:third_step) { service_class.step_class.new(*args, **kwargs.merge(index: 2)) }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: service_class} }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".step" do
      it "adds `step` to `steps`" do
        expect { service_class.step(*args, **kwargs) }.to change { service_class.steps.include?(first_step) }.from(false).to(true)
      end

      specify do
        expect { service_class.step(*args, **kwargs) }
          .to delegate_to(service_class.steps, :create)
          .with_arguments(*args, **kwargs)
      end

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
          )
        end

        before do
          service_class.step(*args, **kwargs)
        end

        it "returns `new expression` that includes `previous expression`" do
          expect(service_class.step(*args, **kwargs)).to eq(new_expression)
        end
      end

      context "when `previous expression is empty`" do
        let(:new_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        it "returns `new expression` that does NOT include `previous expression`" do
          expect(service_class.step(*args, **kwargs)).to eq(new_expression)
        end
      end
    end

    describe ".not_step" do
      it "adds `step` to `steps`" do
        expect { service_class.not_step(*args, **kwargs) }.to change { service_class.steps.include?(first_step) }.from(false).to(true)
      end

      specify do
        expect { service_class.not_step(*args, **kwargs) }
          .to delegate_to(service_class.steps, :create)
          .with_arguments(*args, **kwargs)
      end

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
            )
          )
        end

        before do
          service_class.step(*args, **kwargs)
        end

        it "returns `new expression` that includes `previous expression`" do
          expect(service_class.not_step(*args, **kwargs)).to eq(new_expression)
        end
      end

      context "when `previous expression is empty`" do
        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step)
          )
        end

        it "returns `new expression` that does NOT include `previous expression`" do
          expect(service_class.not_step(*args, **kwargs)).to eq(new_expression)
        end
      end
    end

    describe ".and_step" do
      it "adds `step` to `steps`" do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_step(*args, **kwargs) } }.not_to change { service_class.steps.include?(first_step) }
      end

      specify do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_step(*args, **kwargs) } }.not_to delegate_to(service_class.steps, :create)
      end

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
          )
        end

        before do
          service_class.step(*args, **kwargs)
        end

        it "returns `new expression` that includes `previous expression`" do
          expect(service_class.and_step(*args, **kwargs)).to eq(new_expression)
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.and_step(*args, **kwargs) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_step(*args, **kwargs) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".and_not_step" do
      it "adds `step` to `steps`" do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_not_step(*args, **kwargs) } }.not_to change { service_class.steps.include?(first_step) }
      end

      specify do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_not_step(*args, **kwargs) } }.not_to delegate_to(service_class.steps, :create)
      end

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
            )
          )
        end

        before do
          service_class.step(*args, **kwargs)
        end

        it "returns `new expression` that includes `previous expression`" do
          expect(service_class.and_not_step(*args, **kwargs)).to eq(new_expression)
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.and_not_step(*args, **kwargs) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_not_step(*args, **kwargs) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".or_step" do
      it "adds `step` to `steps`" do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_step(*args, **kwargs) } }.not_to change { service_class.steps.include?(first_step) }
      end

      specify do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_step(*args, **kwargs) } }.not_to delegate_to(service_class.steps, :create)
      end

      context "when `previous expression` is NOT empty" do
        before do
          service_class.step(*args, **kwargs)
        end

        context "when `previous expression` is NOT `and expression`" do
          let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
          let(:new_expression) do
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
            )
          end

          it "returns `new expression` that includes `previous expression`" do
            expect(service_class.or_step(*args, **kwargs)).to eq(new_expression)
          end
        end

        context "when `previous expression` is `and expression`" do
          let(:previous_expression) do
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
            )
          end

          let(:new_expression) do
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step),
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(third_step)
              )
            )
          end

          before do
            service_class.and_step(*args, **kwargs)
          end

          it "returns `new expression` that includes recomposed `previous expression`" do
            expect(service_class.or_step(*args, **kwargs)).to eq(new_expression)
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.or_step(*args, **kwargs) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_step(*args, **kwargs) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".or_not_step" do
      it "adds `step` to `steps`" do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_not_step(*args, **kwargs) } }.not_to change { service_class.steps.include?(first_step) }
      end

      specify do
        expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_not_step(*args, **kwargs) } }.not_to delegate_to(service_class.steps, :create)
      end

      context "when `previous expression` is NOT empty" do
        before do
          service_class.step(*args, **kwargs)
        end

        context "when `previous expression` is NOT `and expression`" do
          let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
          let(:new_expression) do
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
              )
            )
          end

          it "returns `new expression` that includes `previous expression`" do
            expect(service_class.or_not_step(*args, **kwargs)).to eq(new_expression)
          end
        end

        context "when `previous expression` is `and expression`" do
          let(:previous_expression) do
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
            )
          end

          let(:new_expression) do
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step),
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(third_step)
                )
              )
            )
          end

          before do
            service_class.and_step(*args, **kwargs)
          end

          it "returns `new expression` that includes recomposed `previous expression`" do
            expect(service_class.or_not_step(*args, **kwargs)).to eq(new_expression)
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.or_not_step(*args, **kwargs) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_not_step(*args, **kwargs) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".group" do
      let(:block) { proc { service_class.step(*args, **kwargs) } }

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        before do
          service_class.step(*args, **kwargs)
        end

        context "when `block` is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              First step of `group` from `#{service_class}` is NOT set.

              Did you forget to use `step`? For example:

              class #{service_class}
                # ...

                group do
                  step SomeService

                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
            expect { service_class.group }
              .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.group } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `block` is passed" do
          context "when `block` does NOT add any steps" do
            let(:block) { proc {} }

            let(:exception_message) do
              <<~TEXT
                First step of `group` from `#{service_class}` is NOT set.

                Did you forget to use `step`? For example:

                class #{service_class}
                  # ...

                  group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
              expect { service_class.group {} }
                .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.group {} } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `block` adds some steps" do
            let(:block) { proc { service_class.step(*args, **kwargs) } }

            let(:new_expression) do
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                )
              )
            end

            it "returns `new expression` that includes `previous expression`" do
              expect(service_class.group(&block)).to eq(new_expression)
            end
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step)
          )
        end

        it "returns `new expression` that does NOT include `previous expression`" do
          expect(service_class.group(&block)).to eq(new_expression)
        end
      end
    end

    describe ".not_group" do
      let(:block) { proc { service_class.step(*args, **kwargs) } }

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        before do
          service_class.step(*args, **kwargs)
        end

        context "when `block` is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              First step of `not_group` from `#{service_class}` is NOT set.

              Did you forget to use `step`? For example:

              class #{service_class}
                # ...

                not_group do
                  step SomeService

                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
            expect { service_class.not_group }
              .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.not_group } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `block` is passed" do
          context "when `block` does NOT add any steps" do
            let(:block) { proc {} }

            let(:exception_message) do
              <<~TEXT
                First step of `not_group` from `#{service_class}` is NOT set.

                Did you forget to use `step`? For example:

                class #{service_class}
                  # ...

                  not_group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
              expect { service_class.not_group {} }
                .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.not_group {} } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `block` adds some steps" do
            let(:block) { proc { service_class.step(*args, **kwargs) } }

            let(:new_expression) do
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                  )
                )
              )
            end

            it "returns `new expression` that includes `previous expression`" do
              expect(service_class.not_group(&block)).to eq(new_expression)
            end
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:new_expression) do
          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
            ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step)
            )
          )
        end

        it "returns `new expression` that does NOT include `previous expression`" do
          expect(service_class.not_group(&block)).to eq(new_expression)
        end
      end
    end

    describe ".and_group" do
      let(:block) { proc { service_class.step(*args, **kwargs) } }

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        before do
          service_class.step(*args, **kwargs)
        end

        context "when `block` is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              First step of `and_group` from `#{service_class}` is NOT set.

              Did you forget to use `step`? For example:

              class #{service_class}
                # ...

                and_group do
                  step SomeService

                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
            expect { service_class.and_group }
              .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.and_group } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `block` is passed" do
          context "when `block` does NOT add any steps" do
            let(:block) { proc {} }

            let(:exception_message) do
              <<~TEXT
                First step of `and_group` from `#{service_class}` is NOT set.

                Did you forget to use `step`? For example:

                class #{service_class}
                  # ...

                  and_group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
              expect { service_class.and_group {} }
                .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.and_group {} } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `block` adds some steps" do
            let(:block) { proc { service_class.step(*args, **kwargs) } }

            let(:new_expression) do
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                )
              )
            end

            it "returns `new expression` that includes `previous expression`" do
              expect(service_class.and_group(&block)).to eq(new_expression)
            end
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.and_group(&block) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_group(&block) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".and_not_group" do
      let(:block) { proc { service_class.step(*args, **kwargs) } }

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        before do
          service_class.step(*args, **kwargs)
        end

        context "when `block` is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              First step of `and_not_group` from `#{service_class}` is NOT set.

              Did you forget to use `step`? For example:

              class #{service_class}
                # ...

                and_not_group do
                  step SomeService

                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
            expect { service_class.and_not_group }
              .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.and_not_group } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `block` is passed" do
          context "when `block` does NOT add any steps" do
            let(:block) { proc {} }

            let(:exception_message) do
              <<~TEXT
                First step of `and_not_group` from `#{service_class}` is NOT set.

                Did you forget to use `step`? For example:

                class #{service_class}
                  # ...

                  and_not_group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
              expect { service_class.and_not_group {} }
                .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.and_not_group {} } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `block` adds some steps" do
            let(:block) { proc { service_class.step(*args, **kwargs) } }

            let(:new_expression) do
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                  )
                )
              )
            end

            it "returns `new expression` that includes `previous expression`" do
              expect(service_class.and_not_group(&block)).to eq(new_expression)
            end
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.and_not_group(&block) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.and_not_group(&block) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".or_group" do
      let(:block) { proc { service_class.step(*args, **kwargs) } }

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        before do
          service_class.step(*args, **kwargs)
        end

        context "when `block` is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              First step of `or_group` from `#{service_class}` is NOT set.

              Did you forget to use `step`? For example:

              class #{service_class}
                # ...

                or_group do
                  step SomeService

                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
            expect { service_class.or_group }
              .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.or_group } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `block` is passed" do
          context "when `block` does NOT add any steps" do
            let(:block) { proc {} }

            let(:exception_message) do
              <<~TEXT
                First step of `or_group` from `#{service_class}` is NOT set.

                Did you forget to use `step`? For example:

                class #{service_class}
                  # ...

                  or_group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
              expect { service_class.or_group {} }
                .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.or_group {} } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `block` adds some steps" do
            context "when `previous expression` is NOT `and expression`" do
              let(:block) { proc { service_class.step(*args, **kwargs) } }

              let(:new_expression) do
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                  )
                )
              end

              it "returns `new expression` that includes `previous expression`" do
                expect(service_class.or_group(&block)).to eq(new_expression)
              end
            end

            context "when `previous expression` is `and expression`" do
              let(:block) { proc { service_class.step(*args, **kwargs) } }

              let(:previous_expression) do
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                )
              end

              let(:new_expression) do
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step),
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                      ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(third_step)
                    )
                  )
                )
              end

              before do
                service_class.and_step(*args, **kwargs)
              end

              it "returns `new expression` that includes `previous expression`" do
                expect(service_class.or_group(&block)).to eq(new_expression)
              end
            end
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.or_group(&block) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_group(&block) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".or_not_group" do
      let(:block) { proc { service_class.step(*args, **kwargs) } }

      context "when `previous expression` is NOT empty" do
        let(:previous_expression) { ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }

        before do
          service_class.step(*args, **kwargs)
        end

        context "when `block` is NOT passed" do
          let(:exception_message) do
            <<~TEXT
              First step of `or_not_group` from `#{service_class}` is NOT set.

              Did you forget to use `step`? For example:

              class #{service_class}
                # ...

                or_not_group do
                  step SomeService

                  # ...
                end

                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
            expect { service_class.or_not_group }
              .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.or_not_group } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `block` is passed" do
          context "when `block` does NOT add any steps" do
            let(:block) { proc {} }

            let(:exception_message) do
              <<~TEXT
                First step of `or_not_group` from `#{service_class}` is NOT set.

                Did you forget to use `step`? For example:

                class #{service_class}
                  # ...

                  or_not_group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet`" do
              expect { service_class.or_not_group {} }
                .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstGroupStepIsNotSet) { service_class.or_not_group {} } }
                .to delegate_to(ConvenientService, :raise)
            end
          end

          context "when `block` adds some steps" do
            context "when `block` adds some steps" do
              context "when `previous expression` is NOT `and expression`" do
                let(:block) { proc { service_class.step(*args, **kwargs) } }

                let(:new_expression) do
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
                      ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                        ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                      )
                    )
                  )
                end

                it "returns `new expression` that includes `previous expression`" do
                  expect(service_class.or_not_group(&block)).to eq(new_expression)
                end
              end

              context "when `previous expression` is `and expression`" do
                let(:block) { proc { service_class.step(*args, **kwargs) } }

                let(:previous_expression) do
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step)
                  )
                end

                let(:new_expression) do
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::And.new(
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step),
                    ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Or.new(
                      ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step),
                      ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Not.new(
                        ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Group.new(
                          ConvenientService::Plugins::Service::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(third_step)
                        )
                      )
                    )
                  )
                end

                before do
                  service_class.and_step(*args, **kwargs)
                end

                it "returns `new expression` that includes `previous expression`" do
                  expect(service_class.or_not_group(&block)).to eq(new_expression)
                end
              end
            end
          end
        end
      end

      context "when `previous expression is empty`" do
        let(:exception_message) do
          <<~TEXT
            First step of `#{service_class}` is NOT set.

            Did you forget to use `step`? For example:

            class #{service_class}
              # ...

              step SomeService

              # ...
            end
          TEXT
        end

        it "raises `ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet`" do
          expect { service_class.or_not_group(&block) }
            .to raise_error(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Plugins::Service::CanHaveConnectedSteps::Exceptions::FirstStepIsNotSet) { service_class.or_not_group(&block) } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end

    describe ".steps" do
      specify do
        expect { service_class.steps }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection, :new)
          .with_arguments(container: service_class)
          .and_return_its_value
      end

      specify { expect { service_class.steps }.to cache_its_value }

      ##
      # TODO: Implement `delegate_to` that skips block comparion?
      #
      specify do
        expect { service_class.steps }.to delegate_to(service_class.internals_class.cache, :fetch)
      end
    end
  end

  example_group "instance methods" do
    describe "#steps" do
      before do
        service_class.step Class.new, in: :foo, out: :bar
      end

      specify { expect { service_instance.steps }.to delegate_to(service_class.steps, :commit!) }

      it "returns `self.class.steps` with `organizer` set to each of them" do
        expect(service_instance.steps).to eq(service_class.steps.with_organizer(service_instance))
      end

      specify { expect { service_instance.steps }.to cache_its_value }

      specify { expect(service_instance.steps).to be_frozen }

      specify { expect(service_instance.steps).to be_committed }
    end

    describe "#steps_result" do
      context "when service has NO steps" do
        let(:exception_message) do
          <<~TEXT
            #{ConvenientService::Utils::Class.display_name(service_class)} has NO steps.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::ServiceHasNoSteps`" do
          expect { service_instance.steps_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::ServiceHasNoSteps)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::ServiceHasNoSteps) { service_instance.steps_result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when service has steps" do
        context "when intermediate step is NOT successful" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error
              end
            end
          end

          let(:second_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, second_step) do |first_step, second_step|
                include ConvenientService::Standard::Config

                step first_step

                step second_step

                def result
                  success
                end
              end
            end
          end

          it "returns result of intermediate step" do
            expect(service_instance.steps_result).to eq(ConvenientService::Utils::Array.find_last(service_instance.steps, &:completed?).result)
          end

          it "returns result with unchecked status" do
            expect(service_instance.steps_result.checked?).to eq(false)
          end

          it "does NOT evaluate results of following steps" do
            expect { service_instance.steps_result }.not_to delegate_to(second_step, :new)
          end

          it "saves intermediate step outputs into organizer" do
            expect { service_instance.steps_result }.to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!).without_arguments
          end

          it "marks intermediate step as completed" do
            expect { service_instance.steps_result }.to change(service_instance.steps[0], :completed?).from(false).to(true)
          end

          it "triggers callback for intermediate step" do
            expect { service_instance.steps_result }
              .to delegate_to(service_instance.steps[0], :trigger_callback)
              .without_arguments
          end

          it "saves step outputs into organizer" do
            expect { service_instance.steps_result }.not_to delegate_to(service_instance.steps[1], :save_outputs_in_organizer!)
          end

          it "does NOT mark following steps as completed" do
            expect { service_instance.steps_result }.not_to change(service_instance.steps[1], :completed?).from(false)
          end

          it "does NOT trigger callback for following steps" do
            expect { service_instance.steps_result }
              .not_to delegate_to(service_instance.steps[1], :trigger_callback)
              .without_arguments
          end

          example_group "order of side effects" do
            let(:exception) { Class.new(StandardError) }

            before do
              allow(service_instance.steps[0]).to receive(:result).and_raise(exception)
            end

            it "does NOT save step outputs into organizer before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }.not_to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!)
            end

            it "does NOT mark intermediate step as completed before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }.not_to change(service_instance.steps[0], :completed?).from(false)
            end

            it "does NOT trigger callback for intermediate step before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }
                .not_to delegate_to(service_instance.steps[0], :trigger_callback)
                .without_arguments
            end
          end
        end

        context "when all steps are successful" do
          let(:first_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:second_step) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success
              end
            end
          end

          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(first_step, second_step) do |first_step, second_step|
                include ConvenientService::Standard::Config

                step first_step

                step second_step

                def result
                  success
                end
              end
            end
          end

          it "returns result of last step" do
            expect(service_instance.steps_result).to eq(service_instance.steps[-1].result)
          end

          it "returns result with unchecked status" do
            expect(service_instance.steps_result.checked?).to eq(false)
          end

          it "saves intermediate step outputs into organizer" do
            expect { service_instance.steps_result }
              .to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!)
              .without_arguments
          end

          it "marks intermediate step as completed" do
            expect { service_instance.steps_result }.to change(service_instance.steps[0], :completed?).from(false).to(true)
          end

          it "triggers callback for intermediate step" do
            expect { service_instance.steps_result }
              .to delegate_to(service_instance.steps[0], :trigger_callback)
              .without_arguments
          end

          it "saves last step outputs into organizer" do
            expect { service_instance.steps_result }
              .to delegate_to(service_instance.steps[1], :save_outputs_in_organizer!)
              .without_arguments
          end

          it "marks last step as completed" do
            expect { service_instance.steps_result }.to change(service_instance.steps[1], :completed?).from(false).to(true)
          end

          it "triggers callback for last step" do
            expect { service_instance.steps_result }
              .to delegate_to(service_instance.steps[1], :trigger_callback)
              .without_arguments
          end

          example_group "order of side effects" do
            let(:exception) { Class.new(StandardError) }

            before do
              allow(service_instance.steps[0]).to receive(:result).and_raise(exception)
              allow(service_instance.steps[1].status).to receive(:unsafe_not_success?).and_raise(exception)
            end

            it "does NOT save intermediate step outputs into organizer before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }.not_to delegate_to(service_instance.steps[0], :save_outputs_in_organizer!)
            end

            it "does NOT mark intermediate step as completed before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }.not_to change(service_instance.steps[0], :completed?).from(false)
            end

            it "does NOT trigger callback for intermediate step before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }
                .not_to delegate_to(service_instance.steps[0], :trigger_callback)
                .without_arguments
            end

            it "does NOT save last step outputs into organizer before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }.not_to delegate_to(service_instance.steps[1], :save_outputs_in_organizer!)
            end

            it "does NOT mark last step as completed before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }.not_to change(service_instance.steps[1], :completed?).from(false)
            end

            it "does NOT trigger callback for last step before checking status" do
              expect { ignoring_exception(exception) { service_instance.steps_result } }
                .not_to delegate_to(service_instance.steps[1], :trigger_callback)
                .without_arguments
            end
          end
        end
      end
    end

    describe "#step" do
      let(:index) { 0 }

      specify do
        ##
        # NOTE: `service_instance.steps` returns frozen object, that is why it is stubbed.
        #
        allow(service_instance).to receive(:steps).and_return([])

        expect { service_instance.step(index) }
          .to delegate_to(service_instance.steps, :[])
          .with_arguments(index)
          .and_return_its_value
      end

      context "when steps have NO step by index" do
        it "returns `nil`" do
          expect(service_instance.step(index)).to be_nil
        end
      end

      context "when steps have step by index" do
        before do
          service_class.step Class.new, in: :foo, out: :bar
        end

        it "returns step by index" do
          expect(service_instance.step(index)).to eq(service_instance.steps[index])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
