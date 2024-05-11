# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Class::DisplayName, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:utils_result) { described_class.call(klass) }

      context "when `class` is NOT anonymous" do
        let(:klass) { String }

        it "returns `false`" do
          expect(utils_result).to eq("String")
        end
      end

      context "when `class` is anonymous" do
        let(:klass) { Class.new }

        it "returns `true`" do
          expect(utils_result).to eq("AnonymousClass(##{klass.object_id})")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
