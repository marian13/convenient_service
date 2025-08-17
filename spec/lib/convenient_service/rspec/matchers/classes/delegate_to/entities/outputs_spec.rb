# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Outputs, type: :standard do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:outputs) { described_class.new }

  example_group "instance methods" do
    describe "#delegations" do
      it "returns empty array" do
        expect(outputs.delegations).to eq([])
      end

      specify do
        expect { outputs.delegations }.to cache_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:outputs) { described_class.new }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(outputs == other).to be_nil
          end
        end

        context "when `other` has different `delegations`" do
          let(:other) { described_class.new.tap { |outputs| outputs.delegations << double } }

          it "returns `false`" do
            expect(outputs == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new }

          it "returns `true`" do
            expect(outputs == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
