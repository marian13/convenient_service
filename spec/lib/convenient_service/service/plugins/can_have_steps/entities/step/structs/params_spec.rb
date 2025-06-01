# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params, type: :standard do
  example_group "instance methods" do
    describe "#==" do
      let(:kwargs) { {action: Class.new, inputs: [:foo], outputs: [:bar], strict: false, index: 0, organizer: Object.new, extra_kwargs: {fallback: true}} }

      let(:params) { described_class.new(**kwargs) }

      context "when `other` has different `action`" do
        let(:other) { described_class.new(**kwargs.merge(action: Class.new)) }

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

      context "when `other` has different `strict`" do
        let(:other) { described_class.new(**kwargs.merge(strict: true)) }

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

    describe "#to_callback_arguments" do
      let(:kwargs) { {action: Class.new, inputs: [:foo], outputs: [:bar], strict: false, index: 0, organizer: Object.new} }

      let(:params) { described_class.new(**kwargs) }

      it "returns callback arguments" do
        expect(params.to_callback_arguments).to eq(ConvenientService::Support::Arguments.new(params.action, in: params.inputs, out: params.outputs, strict: params.strict, index: params.index))
      end

      context "when params have extra kwargs" do
        let(:kwargs) { {action: Class.new, inputs: [:foo], outputs: [:bar], strict: false, index: 0, organizer: Object.new, extra_kwargs: {fallback: true}} }

        let(:params) { described_class.new(**kwargs) }

        it "returns callback arguments with extra kwargs" do
          expect(params.to_callback_arguments).to eq(ConvenientService::Support::Arguments.new(params.action, in: params.inputs, out: params.outputs, strict: params.strict, index: params.index, fallback: params.extra_kwargs[:fallback]))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
