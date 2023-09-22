# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::DefineMethodInContainer do
  include ConvenientService::RSpec::Helpers::IgnoringException
  include ConvenientService::RSpec::Matchers::DelegateTo

  ##
  # TODO: Helper/factory to create method.
  #
  let(:organizer_service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Minimal

      def foo
        "foo"
      end
    end
  end

  let(:organizer_service_instance) { organizer_service_class.new }

  let(:step_service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Minimal

      def result
        success(data: {bar: "bar"})
      end
    end
  end

  let(:step) { organizer_service_class.step_class.new(step_service_class, in: :foo, out: out, container: organizer_service_class, organizer: organizer_service_instance) }
  let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(organizer_service_class) }
  let(:method) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(out, direction: :output) }
  let(:index) { 0 }
  let(:out) { :bar }

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(method: method, container: container, index: index) }

      it "returns `true`" do
        expect(command_result).to eq(true)
      end

      it "defines `method` in `container`" do
        expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method.to_s, container.klass, private: true) }.from(false).to(true)
      end

      example_group "generated method" do
        before do
          organizer_service_class.class_exec(step) do |step|
            define_method(:steps) { [step] }
          end

          command_result
        end

        context "when step is NOT completed" do
          let(:exception_message) do
            <<~TEXT
              `out` method `#{method}` is called before its corresponding step `#{step.printable_service}` is completed.

              Maybe it makes sense to change the steps order?
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::NotCompletedStep`" do
            expect { organizer_service_instance.bar }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::NotCompletedStep)
              .with_message(exception_message)
          end
        end

        context "when step is completed" do
          before do
            ##
            # NOTE: Completes the step.
            #
            step.mark_as_completed!
          end

          context "when step service result data has NO data attribute by key" do
            let(:out) { {key => :bar} }
            let(:key) { :baz }

            let(:exception_message) do
              <<~TEXT
                Step `#{step.printable_service}` result does NOT return `#{key}` data attribute.

                Maybe there is a typo in `out` definition?

                Or `success` of `#{step.printable_service}` accepts a wrong key?
              TEXT
            end

            it "returns step service result data attribute by key" do
              expect { organizer_service_instance.bar }
                .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::NotExistingStepResultDataAttribute)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::NotExistingStepResultDataAttribute) { organizer_service_instance.bar } }
                .to delegate_to(step.result.unsafe_data, :has_attribute?)
                .with_arguments(method.key.to_sym)
            end
          end

          context "when step service result data has data attribute by key" do
            it "returns step service result data attribute by key" do
              expect(organizer_service_instance.bar).to eq(step.result.unsafe_data[method.key])
            end

            specify do
              expect { organizer_service_instance.bar }
                .to delegate_to(step.result.unsafe_data, :[])
                .with_arguments(method.key.to_sym)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
