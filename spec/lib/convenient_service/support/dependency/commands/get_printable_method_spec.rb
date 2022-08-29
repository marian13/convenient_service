# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Dependency::Commands::GetPrintableMethod do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(method: method, object: object) }
      let(:method) { :foo }

      context "when object is class" do
        let(:object) { Class.new }

        it "returns printable method" do
          expect(command_result).to eq("Class `#{method}'")
        end
      end

      context "when object is instance" do
        let(:klass) { Class.new }
        let(:object) { klass.new }

        it "returns printable method" do
          expect(command_result).to eq("Instance `#{method}'")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
