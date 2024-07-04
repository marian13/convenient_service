# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Commands::IsServiceClass, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(service_class: service_class) }

      context "when `service_class` is NOT class" do
        let(:service_class) { nil }

        it "returns `nil`" do
          expect(command_result).to be_nil
        end
      end

      context "when `service_class` is class" do
        context "when `service_class` does NOT include `ConvenientService::Service::Configs::Essential`" do
          let(:service_class) { Class.new }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when `service_class` does includes `ConvenientService::Service::Configs::Essential`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Service::Configs::Essential
              include ConvenientService::Service::Configs::Inspect

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
