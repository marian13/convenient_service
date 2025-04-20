# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::RawValue, type: :standard do
  let(:object) { 42 }

  example_group "class methods" do
    describe ".wrap" do
      it "returns `ConvenientService::Support::RawValue` instance" do
        expect(described_class.wrap(object)).to be_instance_of(described_class)
      end
    end

    describe ".new" do
      it "is private" do
        expect { described_class.new }.to raise_error(NoMethodError)
      end
    end
  end

  example_group "instance methods" do
    example_group "comparison" do
      describe "#==" do
        let(:object) { :foo }
        let(:raw_value) { described_class.wrap(object) }

        context "when `other` has different class" do
          let(:other) { "string" }

          it "returns `nil`" do
            expect(raw_value == other).to eq(nil)
          end
        end

        context "when `other` has different object" do
          let(:other) { described_class.wrap(:bar) }

          it "returns `false`" do
            expect(raw_value == other).to eq(false)
          end
        end

        context "when `other` has same object" do
          let(:other) { described_class.wrap(:foo) }

          it "returns `true`" do
            expect(raw_value == other).to eq(true)
          end
        end
      end
    end

    describe "#unwrap" do
      it "returns `object`" do
        expect(described_class.wrap(object).unwrap).to eq(object)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
