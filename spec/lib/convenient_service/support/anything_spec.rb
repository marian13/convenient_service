# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Anything do
  let(:anything) { described_class.new(label) }
  let(:label) { :foo }
  let(:default_label) { "anything_#{anything.object_id}" }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { anything }

    it { is_expected.to have_attr_reader(:label) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `label` is NOT passed" do
        let(:anything) { described_class.new }

        it "defaults to `object_id.to_s`" do
          expect(anything.label).to eq(default_label)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#inspect" do
      let(:inspect_representation) { label }

      it "returns inspect representation with label" do
        expect(anything.inspect).to eq(inspect_representation)
      end

      context "when `label` is `nil`" do
        let(:label) { nil }
        let(:inspect_representation) { default_label }

        it "returns inspect representation with default label" do
          expect(anything.inspect).to eq(inspect_representation)
        end
      end

      context "when `label` is empty" do
        let(:label) { "" }
        let(:inspect_representation) { default_label }

        it "returns inspect representation with default label" do
          expect(anything.inspect).to eq(inspect_representation)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:anything) { described_class.new(:foo) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `true`" do
            expect(anything == other).to eq(true)
          end
        end

        context "when `other` has different `object_id`" do
          let(:other) { described_class.new(:bar) }

          it "returns `true`" do
            expect(anything == other).to eq(true)
          end
        end

        context "when `other` has same `object_id`" do
          let(:other) { anything }

          it "returns `true`" do
            expect(anything == other).to eq(true)
          end
        end
      end

      describe "#===" do
        let(:anything) { described_class.new(:foo) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `true`" do
            expect(anything === other).to eq(true)
          end
        end

        context "when `other` has different `object_id`" do
          let(:other) { described_class.new(:bar) }

          it "returns `true`" do
            expect(anything === other).to eq(true)
          end
        end

        context "when `other` has same `object_id`" do
          let(:other) { anything }

          it "returns `true`" do
            expect(anything === other).to eq(true)
          end
        end
      end

      describe ".eql?" do
        let(:anything) { described_class.new(:foo) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `true`" do
            expect(anything.eql?(other)).to eq(true)
          end
        end

        context "when `other` has different `object_id`" do
          let(:other) { described_class.new(:bar) }

          it "returns `true`" do
            expect(anything.eql?(other)).to eq(true)
          end
        end

        context "when `other` has same `object_id`" do
          let(:other) { anything }

          it "returns `true`" do
            expect(anything.eql?(other)).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
