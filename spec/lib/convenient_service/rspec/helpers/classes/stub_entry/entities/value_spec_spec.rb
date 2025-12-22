# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Classes::StubEntry::Entities::ValueSpec, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  let(:value_spec) { described_class.new(value: value, feature_class: feature_class) }

  let(:value) { "some value" }

  let(:feature_class) do
    Class.new do
      include ConvenientService::Feature::Standard::Config
    end
  end

  example_group "class methods" do
    describe ".new" do
      context "when feature class is NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(value: value)).to eq(described_class.new(value: value, feature_class: nil))
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#for" do
      let(:other_feature_class) { Class.new }

      it "returns value spec copy with passed feature class" do
        expect(value_spec.for(other_feature_class)).to eq(described_class.new(value: value, feature_class: other_feature_class))
      end
    end

    describe "#calculate_value" do
      let(:value_spec) { described_class.new(value: value, feature_class: feature_class) }

      it "returns value" do
        expect(value_spec.calculate_value).to eq(value)
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(value_spec == other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { described_class.new(value: :stub_value, feature_class: feature_class) }

          it "returns `false`" do
            expect(value_spec == other).to be(false)
          end
        end

        context "when `other` has different `feature_class`" do
          let(:other) { described_class.new(value: value, feature_class: Class.new) }

          it "returns `false`" do
            expect(value_spec == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(value: value, feature_class: feature_class) }

          it "returns `true`" do
            expect(value_spec == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
