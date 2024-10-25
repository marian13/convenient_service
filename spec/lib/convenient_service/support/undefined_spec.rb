# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Undefined, type: :standard do
  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Support::UniqueValue) }
  end

  example_group "instance methods" do
    describe "#[]" do
      context "when `value` is NOT `ConvenientService::Support::UNDEFINED`" do
        let(:value) { 42 }

        it "returns `false`" do
          expect(ConvenientService::Support::UNDEFINED[value]).to eq(false)
        end
      end

      context "when `value` is `ConvenientService::Support::UNDEFINED`" do
        let(:value) { ConvenientService::Support::UNDEFINED }

        it "returns `true`" do
          expect(ConvenientService::Support::UNDEFINED[value]).to eq(true)
        end
      end
    end
  end

  example_group "constants" do
    describe "::UNDEFINED" do
      it "returns `ConvenientService::Support::Undefined` instance" do
        expect(ConvenientService::Support::UNDEFINED).to be_instance_of(described_class)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(ConvenientService::Support::UNDEFINED.inspect).to eq("undefined")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
