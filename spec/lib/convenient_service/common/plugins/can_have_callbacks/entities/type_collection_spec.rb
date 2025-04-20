# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::TypeCollection, type: :standard do
  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { described_class.new(types: [:before, :result]) }

    it { is_expected.to have_attr_reader(:types) }
  end

  example_group "class methods" do
    describe ".new" do
      subject(:type_collection) { described_class.new(types: types) }

      let(:types) { [:before, :result] }
      let(:casted_types) { types.map(&ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.method(:cast!)) }

      it "casts types to `ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type` instances" do
        expect(type_collection.types).to eq(casted_types)
      end
    end
  end

  example_group "instance methods" do
    subject(:type_collection) { described_class.new(types: types) }

    let(:types) { [:before, :result] }
    let(:other_types) { [:after, :step] }
    let(:casted_types) { types.map(&ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.method(:cast!)) }
    let(:casted_other_types) { other_types.map(&ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.method(:cast!)) }

    describe "#contain_exactly?" do
      it "casts other types" do
        ##
        # NOTE: `initialize` also casts types, that is why `type_collection` is called before `allow` statements.
        #
        type_collection

        allow(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type).to receive(:cast!).with(other_types[0]).and_call_original
        allow(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type).to receive(:cast!).with(other_types[1]).and_call_original

        type_collection.contain_exactly?(other_types)

        expect(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type).to have_received(:cast!).twice
      end

      it "delegates to `ConvenientService::Utils::Array.contain_exactly?`" do
        allow(ConvenientService::Utils::Array).to receive(:contain_exactly?).with(casted_types, casted_other_types).and_call_original

        type_collection.contain_exactly?(other_types)

        expect(ConvenientService::Utils::Array).to have_received(:contain_exactly?)
      end

      it "returns result of delegation to `ConvenientService::Utils::Array.contain_exactly?`" do
        expect(type_collection.contain_exactly?(other_types)).to eq(ConvenientService::Utils::Array.contain_exactly?(types, other_types))
      end
    end

    describe "#==" do
      context "when type collections have different classes" do
        let(:other) { "string" }

        it "returns nil" do
          expect(type_collection == other).to eq(nil)
        end
      end

      context "when type collections have different types" do
        let(:other) { described_class.new(types: [:after, :step]) }

        it "returns false" do
          expect(type_collection == other).to eq(false)
        end
      end

      context "when type collections have same attributes" do
        let(:other) { described_class.new(types: types) }

        it "returns true" do
          expect(type_collection == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
