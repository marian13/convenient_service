# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data do
  let(:data) { described_class.new(value: value) }
  let(:value) { {foo: :bar} }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { data.class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to extend_module(described_class::ClassMethods) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { data }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "instance methods" do
    describe "#[]" do
      it "returns `data` attribute by string key" do
        expect(data["foo"]).to eq(:bar)
      end

      it "returns `data` attribute by symbol key" do
        expect(data[:foo]).to eq(:bar)
      end

      context "when NO `data` attribute exist for passed key" do
        let(:error_message) do
          <<~TEXT
            Data attribute `abc` does NOT exist. Make sure the corresponding result returns it.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Errors::NotExistingAttribute`" do
          expect { data[:abc] }
            .to raise_error(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Errors::NotExistingAttribute)
            .with_message(error_message)
        end
      end
    end
  end

  example_group "comparisons" do
    describe "#==" do
      context "when `other` is NOT castable" do
        let(:other) { 42 }

        before do
          allow(data).to receive(:cast).and_return(nil)
        end

        it "returns `nil`" do
          expect(data == other).to be_nil
        end
      end

      context "when `other` is castable" do
        context "when `other` has different `value`" do
          let(:other) { described_class.new(value: {baz: :qux}) }

          before do
            allow(data).to receive(:cast).and_return(other)
          end

          it "returns `false`" do
            expect(data == other).to eq(false)
          end
        end

        context "when `other` has same `value`" do
          let(:other) { described_class.new(value: {foo: :bar}) }

          before do
            allow(data).to receive(:cast).and_return(other)
          end

          it "returns `true`" do
            expect(data == other).to eq(true)
          end
        end
      end
    end
  end

  example_group "conversions" do
    describe "#to_h" do
      it "returns hash representation of `data`" do
        expect(data.to_h).to eq({foo: :bar})
      end

      it "caches its result" do
        expect(data.to_h.object_id).to eq(data.to_h.object_id)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
