# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Feature::Configs::Standard::Commands::IsFeatureClass, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(feature_class: feature_class) }

      context "when `feature_class` is NOT class" do
        let(:feature_class) { nil }

        it "returns `nil`" do
          expect(command_result).to be_nil
        end
      end

      context "when `feature_class` is class" do
        context "when `feature_class` does NOT include `ConvenientService::Feature::Configs::Standard`" do
          let(:feature_class) { Class.new }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when `feature_class` includes `ConvenientService::Feature::Configs::Standard`" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config

              entry :main

              def main
                :main_entry_value
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `feature_class` includes `ConvenientService::Feature::Configs::Standard` with additional options" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config.with(:rspec)

              entry :main

              def main
                :main_entry_value
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `feature_class` includes `ConvenientService::Feature::Configs::Standard` without some options" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config.without(:rspec)

              entry :main

              def main
                :main_entry_value
              end
            end
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `feature_class` includes `ConvenientService::Feature::Configs::Standard` without default options" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config.without_defaults
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
