# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::IncludeModule do
  describe ".call" do
    let(:other_mod) { Module.new }

    let(:result) { described_class.call(mod, other_mod) }

    context "when `mod` does NOT include `other_mod`" do
      let(:mod) { Class.new }

      it "returns `false`" do
        expect(result).to eq(false)
      end
    end

    context "when `mod` does includes `other_mod`" do
      let(:mod) do
        Class.new.tap do |klass|
          klass.instance_exec(other_mod) do |other_mod|
            include other_mod
          end
        end
      end

      it "returns `true`" do
        expect(result).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
