# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status, type: :standard do
  let(:status) { described_class.new(value: value) }
  let(:value) { :foo }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { status.class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to extend_module(described_class::ClassMethods) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { status }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "instance methods" do
    describe "#success?" do
      context "when `value` is NOT `:success`" do
        it "returns `false`" do
          expect(status.success?).to eq(false)
        end
      end

      context "when `value` is `:success`" do
        let(:value) { :success }

        it "returns `true`" do
          expect(status.success?).to eq(true)
        end
      end
    end

    describe "#failure?" do
      context "when `value` is NOT `:failure`" do
        it "returns `false`" do
          expect(status.failure?).to eq(false)
        end
      end

      context "when `value` is `:failure`" do
        let(:value) { :failure }

        it "returns `true`" do
          expect(status.failure?).to eq(true)
        end
      end
    end

    describe "#error?" do
      context "when `value` is NOT `:error`" do
        it "returns `false`" do
          expect(status.error?).to eq(false)
        end
      end

      context "when `value` is `:error`" do
        let(:value) { :error }

        it "returns `true`" do
          expect(status.error?).to eq(true)
        end
      end
    end

    describe "#not_success?" do
      context "when `value` is NOT `:success`" do
        it "returns `true`" do
          expect(status.not_success?).to eq(true)
        end
      end

      context "when `value` is `:success`" do
        let(:value) { :success }

        it "returns `false`" do
          expect(status.not_success?).to eq(false)
        end
      end
    end

    describe "#not_failure?" do
      context "when `value` is NOT `:failure`" do
        it "returns `true`" do
          expect(status.not_failure?).to eq(true)
        end
      end

      context "when `value` is `:failure`" do
        let(:value) { :failure }

        it "returns `false`" do
          expect(status.not_failure?).to eq(false)
        end
      end
    end

    describe "#not_error?" do
      context "when `value` is NOT `:error`" do
        it "returns `true`" do
          expect(status.not_error?).to eq(true)
        end
      end

      context "when `value` is `:error`" do
        let(:value) { :error }

        it "returns `false`" do
          expect(status.not_error?).to eq(false)
        end
      end
    end
  end

  example_group "comparisons" do
    describe "#==" do
      context "when `other` is NOT castable" do
        let(:other) { 42 }

        before do
          allow(status).to receive(:cast).and_return(nil)
        end

        it "returns `nil`" do
          expect(status == other).to be_nil
        end
      end

      context "when `other` is castable" do
        context "when `other` has different `value`" do
          let(:other) { described_class.new(value: :bar) }

          before do
            allow(status).to receive(:cast).and_return(other)
          end

          it "returns `false`" do
            expect(status == other).to eq(false)
          end
        end

        context "when `other` has same `value`" do
          let(:other) { described_class.new(value: :foo) }

          before do
            allow(status).to receive(:cast).and_return(other)
          end

          it "returns `true`" do
            expect(status == other).to eq(true)
          end
        end
      end
    end
  end

  example_group "conversions" do
    describe "#to_s" do
      it "returns string representation of `status`" do
        expect(status.to_s).to eq("foo")
      end

      it "caches its result" do
        expect(status.to_s.object_id).to eq(status.to_s.object_id)
      end
    end

    describe "#to_sym" do
      it "returns symbol representation of `status`" do
        expect(status.to_sym).to eq(:foo)
      end

      it "caches its result" do
        expect(status.to_sym.object_id).to eq(status.to_sym.object_id)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
