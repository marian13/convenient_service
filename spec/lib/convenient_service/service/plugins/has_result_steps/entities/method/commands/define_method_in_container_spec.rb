# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::DefineMethodInContainer do
  ##
  # TODO: Helper/factory to create method.
  #
  let(:organizer_service_class) do
    Class.new do
      def foo
        "foo"
      end
    end
  end

  let(:organizer_service_instance) { organizer_service_class.new }

  let(:step_service_class) do
    Class.new do
      include ConvenientService::Common::Plugins::HasConstructor::Concern
      include ConvenientService::Service::Plugins::HasResult::Concern

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      class self::Result
        include ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

      def result
        success(data: {bar: "bar"})
      end
    end
  end

  let(:step) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Step.new(step_service_class, in: :foo, out: :bar, container: organizer_service_class, organizer: organizer_service_instance) }

  let(:container) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Service.cast(organizer_service_class) }
  let(:method) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(:bar, direction: :output) }
  let(:index) { 0 }

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
          let(:error_message) do
            <<~TEXT
              `out` method `#{method}` is called before its corresponding step `#{step.service}` is completed.

              Maybe it makes sense to change the steps order?
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::NotCompletedStep`" do
            expect { organizer_service_instance.bar }
              .to raise_error(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::NotCompletedStep)
              .with_message(error_message)
          end
        end

        context "when step is completed" do
          before do
            ##
            # NOTE: Completed the step.
            #
            step.result
          end

          it "returns step service result data by key" do
            expect(organizer_service_instance.bar).to eq(step.result.data[method.key])
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
