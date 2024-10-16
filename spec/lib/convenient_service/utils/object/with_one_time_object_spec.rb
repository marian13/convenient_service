# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Utils::Object::WithOneTimeObject, type: :standard do
  describe ".call" do
    let(:util_result) { described_class.call(&block) }

    let(:block) { proc { |one_time_object| [one_time_object, block_value] } }

    let(:block_value) { :foo }

    it "returns `block` value" do
      expect(util_result.last).to eq(block_value)
    end

    it "passes `Object` instance as `block` argument" do
      expect(util_result.first).to be_instance_of(Object)
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
