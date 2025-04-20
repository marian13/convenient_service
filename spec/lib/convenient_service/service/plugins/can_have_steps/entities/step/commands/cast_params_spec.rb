# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Commands::CastParams, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  example_group "class methods" do
    describe ".call" do
      let(:action) { Class.new }
      let(:inputs) { [:foo] }
      let(:outputs) { [:bar] }
      let(:index) { 0 }
      let(:container) { Class.new }
      let(:organizer) { container.new }
      let(:extra_kwargs) { {fallback: false} }

      let(:original_params) do
        ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params.new(
          action: action,
          inputs: inputs,
          outputs: outputs,
          index: index,
          container: container,
          organizer: organizer,
          extra_kwargs: extra_kwargs
        )
      end

      let(:command_result) { described_class.call(original_params: original_params) }

      example_group "`action`" do
        it "returns `original_params.action`" do
          expect(command_result.action).to eq(original_params.action)
        end

        specify do
          expect { command_result.action }.to cache_its_value
        end
      end

      example_group "`inputs`" do
        it "returns `original_params.inputs` casted to ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method as `inputs`" do
          expect(command_result.inputs).to eq(original_params.inputs.map { |method| ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(method, direction: :input) })
        end

        specify do
          expect { command_result.inputs }.to cache_its_value
        end

        context "when any `input` is NOT castable" do
          let(:inputs) { [42] }

          it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
          end
        end

        context "when last input is hash" do
          context "when that hash has 1 key" do
            let(:inputs) { [:foo, bar: :baz] }

            it "returns `original_params.inputs` casted to ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method as `inputs`" do
              expect(command_result.inputs).to eq([
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :input),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast({bar: :baz}, direction: :input)
              ])
            end
          end

          context "when that hash has mutiple keys" do
            let(:inputs) { [:foo, bar: :baz, qux: :quux] }

            it "cast each key value pair separately" do
              expect(command_result.inputs).to eq([
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :input),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast({bar: :baz}, direction: :input),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast({qux: :quux}, direction: :input)
              ])
            end
          end
        end
      end

      example_group "`outputs`" do
        it "returns `original_params.outputs` casted to ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method as `outputs`" do
          expect(command_result.outputs).to eq(original_params.outputs.map { |method| ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(method, direction: :output) })
        end

        specify do
          expect { command_result.outputs }.to cache_its_value
        end

        context "when any `output` is NOT castable" do
          let(:outputs) { [42] }

          it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
          end
        end

        context "when last output is hash" do
          context "when that hash has 1 key" do
            let(:outputs) { [:foo, bar: :baz] }

            it "returns `original_params.outputs` casted to ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method as `outputs`" do
              expect(command_result.outputs).to eq([
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :output),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast({bar: :baz}, direction: :output)
              ])
            end
          end

          context "when that hash has mutiple keys" do
            let(:outputs) { [:foo, bar: :baz, qux: :quux] }

            it "cast each key value pair separately" do
              expect(command_result.outputs).to eq([
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :output),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast({bar: :baz}, direction: :output),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast({qux: :quux}, direction: :output)
              ])
            end
          end
        end
      end

      example_group "`index`" do
        it "returns `original_params.index`" do
          expect(command_result.index).to eq(original_params.index)
        end

        specify do
          expect { command_result.index }.to cache_its_value
        end
      end

      example_group "`container`" do
        it "returns `original_params.container`" do
          expect(command_result.container).to eq(original_params.container)
        end

        specify do
          expect { command_result.container }.to cache_its_value
        end

        context "when `container` is NOT castable" do
          let(:container) { 42 }
          let(:organizer) { Object.new }

          it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
            expect { command_result }.to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
          end
        end
      end

      example_group "`organizer`" do
        it "returns `original_params.organizer`" do
          expect(command_result.organizer).to eq(original_params.organizer)
        end

        specify do
          expect { command_result.organizer }.to cache_its_value
        end
      end

      example_group "`extra_kwargs`" do
        it "returns `original_params.extra_kwargs`" do
          expect(command_result.extra_kwargs).to eq(original_params.extra_kwargs)
        end

        specify do
          expect { command_result.extra_kwargs }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
