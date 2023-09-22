# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base::Commands::GenerateGotStepPart do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      context "when matcher is NOT chained by `of_step`" do
        let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher is chained by `of_step`" do
        let(:matcher) { be_success.of_step(step).tap { |matcher| matcher.matches?(result) } }
        let(:step) { :foo }

        context "when result has NO step" do
          it "returns part without step" do
            expect(command_result).to eq("without step")
          end
        end

        context "when result has step" do
          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              step :foo

              def foo
                success
              end
            end
          end

          it "returns part with step" do
            expect(command_result).to eq("of step `#{result.step.printable_service}`")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
