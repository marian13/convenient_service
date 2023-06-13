# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Commands::FindMethod do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(step: step) }
      let(:step) { service.steps.first }

      context "when step service klass none of `ConvenientService::Services::RunMethodInOrganizer` or `ConvenientService::Services::RunOwnMethodInOrganizer`" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step
            end
          end
        end

        it "return `nil`" do
          expect(command_result).to be_nil
        end
      end

      context "when step service klass is `ConvenientService::Services::RunMethodInOrganizer`" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Standard

            step :foo

            def foo
              success
            end
          end
        end

        context "when step does NOT have input with `:method_name` key" do
          before do
            step.inputs.delete_if { |input| input.key.to_sym == :method_name }
          end

          it "return `nil`" do
            expect(command_result).to be_nil
          end
        end

        context "when step has input with `:method_name` key" do
          let(:method) { step.inputs.find { |input| input.key.to_sym == :method_name } }

          it "returns that input" do
            expect(command_result).to eq(method)
          end
        end
      end

      context "when step service klass is `ConvenientService::Services::RunOwnMethodInOrganizer`" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Standard

            step :result

            def result
              success
            end
          end
        end

        context "when step does NOT have input with `:method_name` key" do
          before do
            step.inputs.delete_if { |input| input.key.to_sym == :method_name }
          end

          it "return `nil`" do
            expect(command_result).to be_nil
          end
        end

        context "when step has input with `:method_name` key" do
          let(:method) { step.inputs.find { |input| input.key.to_sym == :method_name } }

          it "returns that input" do
            expect(command_result).to eq(method)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
