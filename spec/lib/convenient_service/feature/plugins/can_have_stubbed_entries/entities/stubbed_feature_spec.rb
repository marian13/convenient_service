# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::StubbedFeature, type: :standard do
  include ConvenientService::RSpec::Helpers::StubEntry

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  subject(:helper) { described_class.new(feature_class: feature_class, entry_name: entry_name) }

  let(:feature_class) do
    Class.new do
      include ConvenientService::Feature::Standard::Config

      entry :main

      def main(*args, **kwargs, &block)
        :main_entry_value
      end
    end
  end

  let(:entry_name) { :main }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:value_spec) { ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueSpec.new(value: "some value") }
  let(:value) { value_spec.for(feature_class).calculate_value }

  example_group "instance methods" do
    describe "#with_any_arguments" do
      it "returns self" do
        expect(helper.with_any_arguments).to eq(helper)
      end

      context "when method is called without arguments" do
        it "modifies method to return stub" do
          stub_entry(feature_class, entry_name).with_any_arguments.to return_value(:with_any_arguments)

          expect(feature_class.main).to eq(:with_any_arguments)
        end
      end

      context "when method is called with arguments" do
        it "modifies method to return stub" do
          stub_entry(feature_class, entry_name).with_any_arguments.to return_value(:with_any_arguments)

          expect(feature_class.main(*args, **kwargs, &block)).to eq(:with_any_arguments)
        end
      end
    end

    describe "#with_arguments" do
      it "returns self" do
        expect(helper.with_arguments(*args, **kwargs, &block)).to eq(helper)
      end

      context "when method is NOT called with arguments" do
        it "does NOT modify method to return stub" do
          stub_entry(feature_class, entry_name).with_arguments(*args, **kwargs, &block).to return_value(:with_arguments)

          expect(feature_class.main).to eq(:main_entry_value)
        end
      end

      context "when method is called with arguments" do
        it "modifies method to return stub" do
          stub_entry(feature_class, entry_name).with_arguments(*args, **kwargs, &block).to return_value(:with_arguments)

          expect(feature_class.main(*args, **kwargs, &block)).to eq(:with_arguments)
        end
      end
    end

    describe "#without_arguments" do
      it "returns self" do
        expect(helper.without_arguments).to eq(helper)
      end

      context "when method is NOT called without arguments" do
        it "modifies method to return stub" do
          stub_entry(feature_class, entry_name).without_arguments.to return_value(:stub_value)

          expect(feature_class.main(*args, **kwargs, &block)).to eq(:main_entry_value)
        end
      end

      context "when method is called without arguments" do
        it "modifies method to return stub" do
          stub_entry(feature_class, entry_name).without_arguments.to return_value(:stub_value)

          expect(feature_class.main).to eq(:stub_value)
        end
      end
    end

    describe "#to" do
      let(:key) { feature_class.stubbed_entries.keygen }

      it "returns `self`" do
        expect(helper.to(value_spec)).to eq(helper)
      end

      specify do
        expect { helper.to(value_spec) }
          .to delegate_to(feature_class, :commit_config!)
          .with_arguments(trigger: ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Constants::Triggers::STUB_ENTRY)
      end

      specify do
        expect { helper.to(value_spec) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries, :set_feature_stubbed_entry)
          .with_arguments(feature_class, entry_name, nil, value)
      end

      context "when used with `with_arguments`" do
        let(:key) { feature_class.stubbed_entries.keygen(*args, **kwargs, &block) }

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to(value_spec) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries, :set_feature_stubbed_entry)
            .with_arguments(feature_class, entry_name, ConvenientService::Support::Arguments.new(*args, **kwargs, &block), value)
        end
      end

      context "when used with `without_arguments`" do
        let(:key) { feature_class.stubbed_entries.keygen(*args, **kwargs, &block) }

        specify do
          expect { helper.without_arguments.to(value_spec) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries, :set_feature_stubbed_entry)
            .with_arguments(feature_class, entry_name, ConvenientService::Support::Arguments.null_arguments, value)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:helper) { described_class.new(feature_class: feature_class, entry_name: entry_name) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(helper == other).to be_nil
          end
        end

        context "when `other` has different `feature_class`" do
          let(:other) { described_class.new(feature_class: Class.new, entry_name: entry_name) }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has different `entry_name`" do
          let(:other) { described_class.new(feature_class: feature_class, entry_name: :foo) }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has different `arguments`" do
          let(:other) { described_class.new(feature_class: feature_class, entry_name: entry_name).with_arguments(:foo, :bar) }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has different `value_spec`" do
          let(:other) { described_class.new(feature_class: feature_class, entry_name: entry_name).to return_value(:stub_value) }

          it "returns `false`" do
            expect(helper == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(feature_class: feature_class, entry_name: entry_name) }

          it "returns `true`" do
            expect(helper == other).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
