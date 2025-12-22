# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Value, type: :standard do
  let(:value) { described_class.new(label) }
  let(:label) { "foo" }
  let(:default_label) { "value" }

  example_group "attributes" do
    subject { value }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    it { is_expected.to respond_to(:label) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `label` is NOT passed" do
        let(:value) { described_class.new }

        it "defaults to `\"value\"`" do
          expect(value.label).to eq(default_label)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#hash" do
      it "returns hash based on class and label" do
        expect(value.hash).to eq([described_class, label].hash)
      end
    end

    describe "#inspect" do
      let(:inspect_representation) { label }

      it "returns inspect representation with label" do
        expect(value.inspect).to eq(inspect_representation)
      end

      context "when `label` is `nil`" do
        let(:label) { nil }
        let(:inspect_representation) { default_label }

        it "returns inspect representation with default label" do
          expect(value.inspect).to eq(inspect_representation)
        end
      end

      context "when `label` is empty" do
        let(:label) { "" }
        let(:inspect_representation) { default_label }

        it "returns inspect representation with default label" do
          expect(value.inspect).to eq(inspect_representation)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:value) { described_class.new("foo") }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(value == other).to be_nil
          end
        end

        context "when `other` has different `label`" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(value == other).to be(false)
          end
        end

        context "when `other` has same `label`" do
          let(:other) { described_class.new("foo") }

          it "returns `true`" do
            expect(value == other).to be(true)
          end
        end
      end

      describe "#===" do
        let(:value) { described_class.new("foo") }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(value === other).to be_nil
          end
        end

        context "when `other` has different `label`" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(value === other).to be(false)
          end
        end

        context "when `other` has same `label`" do
          let(:other) { described_class.new("foo") }

          it "returns `true`" do
            expect(value === other).to be(true)
          end
        end
      end

      describe "#eql?" do
        let(:value) { described_class.new("foo") }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(value.eql?(other)).to be_nil
          end
        end

        context "when `other` has different `label`" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(value.eql?(other)).to be(false)
          end
        end

        context "when `other` has same `label`" do
          let(:other) { described_class.new("foo") }

          it "returns `true`" do
            expect(value.eql?(other)).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
