# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:value_mock) { described_class.new(value: value, feature_class: feature_class, entry_name: entry_name, arguments: arguments) }

  let(:value) { "some value" }

  let(:feature_class) do
    Class.new do
      include ConvenientService::Feature::Standard::Config
    end
  end

  let(:entry_name) { :main }
  let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }

  example_group "class methods" do
    describe ".new" do
      context "when feature class is NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(value: value, entry_name: entry_name, arguments: arguments)).to eq(described_class.new(value: value, feature_class: nil, entry_name: entry_name, arguments: arguments))
        end
      end

      context "when entry name is NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(value: value, feature_class: feature_class, arguments: arguments)).to eq(described_class.new(value: value, feature_class: feature_class, entry_name: nil, arguments: arguments))
        end
      end

      context "when arguments are NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(value: value, feature_class: feature_class, entry_name: entry_name)).to eq(described_class.new(value: value, feature_class: feature_class, entry_name: entry_name, arguments: nil))
        end
      end
    end
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { value_mock }

      it { is_expected.to have_attr_reader(:value) }
    end

    describe "#for" do
      let(:other_feature_class) { Class.new }
      let(:other_entry_name) { :init }
      let(:other_arguments) { ConvenientService::Support::Arguments.new(:bar, {bar: :baz}) { :bar } }

      it "returns value spec copy with passed feature class" do
        expect(value_mock.for(other_feature_class, other_entry_name, other_arguments)).to eq(described_class.new(value: value, feature_class: other_feature_class, entry_name: other_entry_name, arguments: other_arguments))
      end
    end

    describe "#register" do
      specify do
        expect { value_mock.register }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::SetFeatureStubbedEntry, :call)
            .with_arguments(feature: feature_class, entry: entry_name, arguments: arguments, value: value)
            .and_return { value_mock }
      end
    end

    describe "#unregister" do
      specify do
        expect { value_mock.unregister }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::DeleteFeatureStubbedEntry, :call)
            .with_arguments(feature: feature_class, entry: entry_name, arguments: arguments)
            .and_return { value_mock }
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(value_mock == other).to be_nil
          end
        end

        context "when `other` has different `value`" do
          let(:other) { described_class.new(value: :stub_value, feature_class: feature_class, entry_name: entry_name, arguments: arguments) }

          it "returns `false`" do
            expect(value_mock == other).to be(false)
          end
        end

        context "when `other` has different `feature_class`" do
          let(:other) { described_class.new(value: value, feature_class: Class.new, entry_name: entry_name, arguments: arguments) }

          it "returns `false`" do
            expect(value_mock == other).to be(false)
          end
        end

        context "when `other` has different `entry_name`" do
          let(:other) { described_class.new(value: value, feature_class: feature_class, entry_name: :init, arguments: arguments) }

          it "returns `false`" do
            expect(value_mock == other).to be(false)
          end
        end

        context "when `other` has different `arguments`" do
          let(:other) { described_class.new(value: value, feature_class: feature_class, entry_name: entry_name, arguments: ConvenientService::Support::Arguments.null_arguments) }

          it "returns `false`" do
            expect(value_mock == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(value: value, feature_class: feature_class, entry_name: entry_name, arguments: arguments) }

          it "returns `true`" do
            expect(value_mock == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
