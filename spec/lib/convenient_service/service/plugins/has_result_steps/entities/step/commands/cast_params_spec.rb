# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Commands::CastParams do
  example_group "class methods" do
    describe ".call" do
      let(:service) { Class.new }
      let(:inputs) { [:foo] }
      let(:outputs) { [:bar] }
      let(:index) { 0 }
      let(:container) { Class.new }
      let(:organizer) { container.new }

      let(:original_params) do
        ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Structs::Params.new(
          service: service,
          inputs: inputs,
          outputs: outputs,
          index: index,
          container: container,
          organizer: organizer
        )
      end

      let(:command_result) { described_class.call(original_params: original_params) }

      example_group "`service'" do
        it "returns `original_params.service' casted to `ConvenientService::Service::Plugins::HasResultSteps::Entities::Service' as `service'" do
          expect(command_result.service).to eq(ConvenientService::Service::Plugins::HasResultSteps::Entities::Service.cast(original_params.service))
        end

        context "when `service' is NOT castable" do
          let(:service) { 42 }

          it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
          end
        end
      end

      example_group "`inputs'" do
        it "returns `original_params.inputs' casted to ConvenientService::Service::Plugins::HasResultSteps::Entities::Method as `inputs'" do
          expect(command_result.inputs).to eq(original_params.inputs.map { |method| ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(method, direction: :input) })
        end

        context "when any `input' is NOT castable" do
          let(:inputs) { [42] }

          it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
          end
        end
      end

      example_group "`outputs'" do
        it "returns `original_params.outputs' casted to ConvenientService::Service::Plugins::HasResultSteps::Entities::Method as `outputs'" do
          expect(command_result.outputs).to eq(original_params.outputs.map { |method| ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(method, direction: :output) })
        end

        context "when any `output' is NOT castable" do
          let(:outputs) { [42] }

          it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
          end
        end
      end

      example_group "`index'" do
        it "returns `original_params.index'" do
          expect(command_result.index).to eq(original_params.index)
        end
      end

      example_group "`container'" do
        it "returns `original_params.container'" do
          expect(command_result.container).to eq(original_params.container)
        end

        context "when `container' is NOT castable" do
          let(:container) { 42 }
          let(:organizer) { Object.new }

          it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
          end
        end
      end

      example_group "`organizer'" do
        it "returns `original_params.organizer'" do
          expect(command_result.organizer).to eq(original_params.organizer)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
