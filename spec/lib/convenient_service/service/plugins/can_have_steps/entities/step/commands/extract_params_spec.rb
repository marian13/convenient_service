# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Commands::ExtractParams do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      let(:args) { [Class.new] }
      let(:default_kwargs) { {in: [:foo], out: [:bar], index: index, container: container, organizer: organizer} }
      let(:kwargs) { default_kwargs }
      let(:index) { 0 }
      let(:container) { Object }
      let(:organizer) { Object.new }
      let(:command_result) { described_class.call(args: args, kwargs: kwargs) }

      example_group "`service`" do
        it "returns `args.first` as `service`" do
          expect(command_result.service).to eq(args.first)
        end
      end

      example_group "`in`" do
        it "returns `kwargs[:in]` as `inputs`" do
          expect(command_result.inputs).to eq(kwargs[:in])
        end

        context "when `kwargs[:in]` is NOT passed" do
          let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:in]) }

          it "defaults `inputs` to empty array" do
            expect(command_result.inputs).to eq([])
          end
        end

        context "when `kwargs[:in]` is single value" do
          let(:kwargs) { default_kwargs.merge(in: :foo) }

          it "wraps `inputs` by array" do
            expect(command_result.inputs).to be_instance_of(Array)
          end
        end
      end

      example_group "`out`" do
        it "returns `kwargs[:out]` as `outputs`" do
          expect(command_result.outputs).to eq(kwargs[:out])
        end

        context "when `kwargs[:out]` is NOT passed" do
          let(:kwargs) { ConvenientService::Utils::Hash.except(default_kwargs, [:out]) }

          it "defaults `outputs` to empty array" do
            expect(command_result.outputs).to eq([])
          end
        end

        context "when `kwargs[:out]` is single value" do
          let(:kwargs) { default_kwargs.merge(out: :foo) }

          it "wraps `outputs` by array" do
            expect(command_result.outputs).to be_instance_of(Array)
          end
        end
      end

      example_group "`index`" do
        it "returns `kwargs[:index]` as `index`" do
          expect(command_result.index).to eq(index)
        end
      end

      example_group "`container`" do
        it "returns `kwargs[:container]` as `container`" do
          expect(command_result.container).to eq(container)
        end
      end

      example_group "`organizer`" do
        it "returns `kwargs[:organizer]` as `organizer`" do
          expect(command_result.organizer).to eq(organizer)
        end
      end

      example_group "`extra_kwargs`" do
        let(:default_kwargs) { {in: [:foo], out: [:bar], index: index, organizer: organizer, fallback: false} }

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Utils::Hash, :except)
            .with_arguments(default_kwargs, [:in, :out, :index, :container, :organizer])
        end

        it "returns `kwargs` without `[:in, :out, :index, :container, :organizer]` keys as `extra_kwargs`" do
          expect(command_result.extra_kwargs).to eq({fallback: false})
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
