# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Commands::GeneratePrintableMethod do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(object: object, method: method) }

      context "when `object` is class" do
        let(:object) do
          Class.new do
            def self.bar
            end
          end
        end

        let(:method) { :bar }

        it "returns string in `class.method` format" do
          expect(command_result).to eq("#{object}.#{method}")
        end
      end

      context "when `object` is module" do
        let(:object) do
          Module.new do
            def self.bar
            end
          end
        end

        let(:method) { :bar }

        it "returns string in `module.method` format" do
          expect(command_result).to eq("#{object}.#{method}")
        end
      end

      context "when `object` is instance" do
        let(:klass) do
          Class.new do
            def bar
            end
          end
        end

        let(:object) { klass.new }
        let(:method) { :bar }

        it "returns string in `class#method` format" do
          expect(command_result).to eq("#{klass}##{method}")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
