# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base::Structs::IntendedMethod do
  example_group "instance methods" do
    describe "#==" do
      let(:kwargs) { {method: :result, scope: :instance, entity: :service} }

      let(:intented_method) { described_class.new(**kwargs) }

      context "when `other` has different `method`" do
        let(:other) { described_class.new(**kwargs.merge(method: :initialize)) }

        it "returns `false`" do
          expect(intented_method == other).to eq(false)
        end
      end

      context "when `other` has different `scope`" do
        let(:other) { described_class.new(**kwargs.merge(scope: :class)) }

        it "returns `false`" do
          expect(intented_method == other).to eq(false)
        end
      end

      context "when `other` has different `entity`" do
        let(:other) { described_class.new(**kwargs.merge(entity: :result)) }

        it "returns `false`" do
          expect(intented_method == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(**kwargs) }

        it "returns `true`" do
          expect(intented_method == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
