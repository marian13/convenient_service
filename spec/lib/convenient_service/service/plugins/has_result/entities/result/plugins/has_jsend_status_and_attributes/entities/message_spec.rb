# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message do
  let(:message) { described_class.new(value: value) }
  let(:value) { "foo" }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { message.class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to extend_module(described_class::ClassMethods) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { message }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "comparisons" do
    describe "#==" do
      context "when `other` is NOT castable" do
        let(:other) { 42 }

        before do
          allow(message).to receive(:cast).and_return(nil)
        end

        it "returns `nil`" do
          expect(message == other).to be_nil
        end
      end

      context "when `other` is castable" do
        context "when `other` has different `value`" do
          let(:other) { described_class.new(value: "bar") }

          before do
            allow(message).to receive(:cast).and_return(other)
          end

          it "returns `false`" do
            expect(message == other).to eq(false)
          end
        end

        context "when `other` has same `value`" do
          let(:other) { described_class.new(value: "foo") }

          before do
            allow(message).to receive(:cast).and_return(other)
          end

          it "returns `true`" do
            expect(message == other).to eq(true)
          end
        end
      end
    end
  end

  example_group "conversions" do
    describe "#to_s" do
      it "returns string representation of `message`" do
        expect(message.to_s).to eq("foo")
      end

      it "caches its result" do
        expect(message.to_s.object_id).to eq(message.to_s.object_id)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
