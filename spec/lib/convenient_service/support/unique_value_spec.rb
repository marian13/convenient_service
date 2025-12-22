# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::UniqueValue, type: :standard do
  let(:unique_value) { described_class.new(label) }
  let(:label) { "foo" }
  let(:default_label) { "unique_value_#{unique_value.object_id}" }

  example_group "attributes" do
    subject { unique_value }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    it { is_expected.to respond_to(:label) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `label` is NOT passed" do
        let(:unique_value) { described_class.new }

        it "defaults to `object_id.to_s`" do
          expect(unique_value.label).to eq(default_label)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#hash" do
      it "returns hash based on class and label" do
        expect(unique_value.hash).to eq([described_class, label].hash)
      end
    end

    describe "#inspect" do
      let(:inspect_representation) { label }

      it "returns inspect representation with label" do
        expect(unique_value.inspect).to eq(inspect_representation)
      end

      context "when `label` is `nil`" do
        let(:label) { nil }
        let(:inspect_representation) { default_label }

        it "returns inspect representation with default label" do
          expect(unique_value.inspect).to eq(inspect_representation)
        end
      end

      context "when `label` is empty" do
        let(:label) { "" }
        let(:inspect_representation) { default_label }

        it "returns inspect representation with default label" do
          expect(unique_value.inspect).to eq(inspect_representation)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:unique_value) { described_class.new("foo") }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(unique_value == other).to be_nil
          end
        end

        context "when `other` has different `object_id`" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(unique_value == other).to be(false)
          end
        end

        context "when `other` has same `object_id`" do
          let(:other) { unique_value }

          it "returns `true`" do
            expect(unique_value == other).to be(true)
          end
        end
      end

      describe "#===" do
        let(:unique_value) { described_class.new("foo") }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(unique_value === other).to be_nil
          end
        end

        context "when `other` has different `object_id`" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(unique_value === other).to be(false)
          end
        end

        context "when `other` has same `object_id`" do
          let(:other) { unique_value }

          it "returns `true`" do
            expect(unique_value === other).to be(true)
          end
        end
      end

      describe "#eql?" do
        let(:unique_value) { described_class.new("foo") }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(unique_value.eql?(other)).to be_nil
          end
        end

        context "when `other` has different `object_id`" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(unique_value.eql?(other)).to be(false)
          end
        end

        context "when `other` has same `object_id`" do
          let(:other) { unique_value }

          it "returns `true`" do
            expect(unique_value.eql?(other)).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
