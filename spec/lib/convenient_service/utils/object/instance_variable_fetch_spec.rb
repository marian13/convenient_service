# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Object::InstanceVariableFetch do
  describe ".call" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:ivar_value) { :bar }
    let(:fallback_block) { proc { :baz } }

    context "when ivar is NOT defined" do
      context "when `fallback_block` is NOT passed" do
        let(:result) { described_class.call(object, ivar_name) }

        it "returns `nil`" do
          expect(result).to be_nil
        end
      end

      context "when `fallback_block` is passed" do
        let(:result) { described_class.call(object, ivar_name, &fallback_block) }

        it "returns `fallback_block` value" do
          expect(result).to eq(fallback_block.call)
        end

        it "set ivar to `fallback_block` value" do
          result

          expect(object.instance_variable_get(ivar_name)).to eq(fallback_block.call)
        end
      end
    end

    context "when ivar is defined" do
      let(:object) do
        Object.new.tap do |object|
          object.instance_variable_set(ivar_name, ivar_value)
        end
      end

      context "when `fallback_block` is NOT passed" do
        let(:result) { described_class.call(object, ivar_name) }

        it "returns that ivar value" do
          expect(result).to eq(ivar_value)
        end
      end

      context "when `fallback_block` is passed" do
        let(:result) { described_class.call(object, ivar_name, &fallback_block) }

        it "returns that ivar value" do
          expect(result).to eq(ivar_value)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
