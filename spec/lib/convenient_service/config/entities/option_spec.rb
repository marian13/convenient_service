# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Config::Entities::Option, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:option) { described_class.new(name: name, enabled: enabled, **data) }

  let(:name) { :fallbacks }
  let(:enabled) { true }
  let(:data) { {status: :failure, exception: false} }

  example_group "class methods" do
    describe ".new" do
      context "when `enabled` is NOT passed" do
        let(:option) { described_class.new(name: name, **data) }

        it "defaults to `false`" do
          expect(option.enabled?).to eq(false)
        end
      end

      context "when `data` is NOT passed" do
        let(:option) { described_class.new(name: name, enabled: enabled) }

        it "defaults to empty hash" do
          expect(option.data).to eq({})
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { option }

      it { is_expected.to have_attr_reader(:name) }
      it { is_expected.to have_attr_reader(:data) }
    end

    describe "#enabled?" do
      context "when `enabled` is falsy in `Utils.to_bool` terms" do
        let(:enabled) { false }

        it "returns `false`" do
          expect(option.enabled?).to eq(false)
        end
      end

      context "when `enabled` is truthy in `Utils.to_bool` terms" do
        let(:enabled) { true }

        it "returns `true`" do
          expect(option.enabled?).to eq(true)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(option == other).to be_nil
          end
        end

        context "when `other` have different `name`" do
          let(:other) { described_class.new(name: :rollbacks) }

          it "returns `false`" do
            expect(option == other).to eq(false)
          end
        end

        context "when `other` have different `enabled`" do
          let(:other) { described_class.new(name: name, enabled: false, **data) }

          it "returns `false`" do
            expect(option == other).to eq(false)
          end
        end

        context "when `other` have different `data`" do
          let(:other) { described_class.new(name: name, enabled: enabled, status: :error) }

          it "returns `false`" do
            expect(option == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(name: name, enabled: enabled, **data) }

          it "returns `true`" do
            expect(option == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
