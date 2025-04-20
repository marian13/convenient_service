# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateGotParts, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: printer) }

      let(:matcher) { be_success.with_data(data).of_service(service).of_step(step).tap { |matcher| matcher.matches?(result) } }
      let(:printer) { matcher.printer }
      let(:data) { {foo: :bar} }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          step :foo

          def foo
            success(foo: :bar)
          end
        end
      end

      let(:step) { :foo }
      let(:result) { service.result }

      ##
      # NOTE: This context also checks order.
      #
      context "when matcher uses all chains" do
        let(:matcher) { be_success.with_data(data).of_service(service).of_step(step).tap { |matcher| matcher.matches?(result) } }

        let(:parts) do
          [
            "got result",
            printer.got_jsend_attributes_part,
            printer.got_service_part,
            printer.got_step_part
          ]
        end

        it "returns parts concated by newlines" do
          expect(command_result).to eq(parts.join("\n"))
        end
      end

      context "when matcher does NOT use any chain" do
        let(:matcher) { be_success.with_data(data).of_step(step).tap { |matcher| matcher.matches?(result) } }

        let(:parts) do
          [
            "got result",
            printer.got_jsend_attributes_part,
            printer.got_step_part
          ]
        end

        it "skips that chain part" do
          expect(command_result).to eq(parts.join("\n"))
        end
      end

      context "when matcher does NOT use multiple chains" do
        let(:matcher) { be_success.with_data(data).tap { |matcher| matcher.matches?(result) } }

        let(:parts) do
          [
            "got result",
            printer.got_jsend_attributes_part
          ]
        end

        it "skips those chains parts" do
          expect(command_result).to eq(parts.join("\n"))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
