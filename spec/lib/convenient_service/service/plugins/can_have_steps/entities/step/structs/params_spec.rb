# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params do
  example_group "instance methods" do
    describe "#==" do
      let(:kwargs) { {service: Class.new, inputs: [:foo], outputs: [:bar], index: 0, organizer: Object.new, extra_kwargs: {fallback: true}} }

      let(:params) { described_class.new(**kwargs) }

      context "when `other` has different `service`" do
        let(:other) { described_class.new(**kwargs.merge(service: Class.new)) }

        it "returns `false`" do
          expect(params == other).to eq(false)
        end
      end

      context "when `other` has different `inputs`" do
        let(:other) { described_class.new(**kwargs.merge(inputs: [:baz])) }

        it "returns `false`" do
          expect(params == other).to eq(false)
        end
      end

      context "when `other` has different `outputs`" do
        let(:other) { described_class.new(**kwargs.merge(outputs: [:qux])) }

        it "returns `false`" do
          expect(params == other).to eq(false)
        end
      end

      context "when `other` has different `index`" do
        let(:other) { described_class.new(**kwargs.merge(index: 1)) }

        it "returns `false`" do
          expect(params == other).to eq(false)
        end
      end

      context "when `other` has different `organizer`" do
        let(:other) { described_class.new(**kwargs.merge(organizer: Object.new)) }

        it "returns `false`" do
          expect(params == other).to eq(false)
        end
      end

      context "when `other` has different `extra_kwargs`" do
        let(:other) { described_class.new(**kwargs.merge(extra_kwargs: {fallback: false})) }

        it "returns `false`" do
          expect(params == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(**kwargs) }

        it "returns `true`" do
          expect(params == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
