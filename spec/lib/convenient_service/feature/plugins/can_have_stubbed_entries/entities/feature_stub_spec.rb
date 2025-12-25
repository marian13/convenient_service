# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureStub, type: :standard do
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

  let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:value_mock) { ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock.new(value: "some value") }
  let(:value) { value_mock.for(feature_class, entry_name, arguments).value }

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
      it "returns `self`" do
        expect(helper.to(value_mock)).to eq(helper)
      end

      specify do
        expect { helper.to(value_mock) }
          .to delegate_to(value_mock, :for)
          .with_arguments(feature_class, entry_name, nil)
      end

      specify do
        expect { helper.to(value_mock) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::SetFeatureStubbedEntry, :call)
          .with_arguments(feature: feature_class, entry: entry_name, arguments: nil, value: value)
      end

      specify do
        other_value_mock = ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock.new(value: :value).for(feature_class, entry_name, nil)

        allow(value_mock).to receive(:for).with(feature_class, entry_name, nil).and_return(other_value_mock)

        expect { helper.to(value_mock) }
          .to delegate_to(other_value_mock, :register)
          .without_arguments
      end

      context "when used with `with_any_arguments`" do
        let(:arguments) { nil }

        specify do
          expect { helper.with_any_arguments.to(value_mock) }
            .to delegate_to(value_mock, :for)
            .with_arguments(feature_class, entry_name, arguments)
        end

        specify do
          expect { helper.with_any_arguments.to(value_mock) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::SetFeatureStubbedEntry, :call)
            .with_arguments(feature: feature_class, entry: entry_name, arguments: arguments, value: value)
        end
      end

      context "when used with `with_arguments`" do
        let(:arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to(value_mock) }
            .to delegate_to(value_mock, :for)
            .with_arguments(feature_class, entry_name, arguments)
        end

        specify do
          expect { helper.with_arguments(*args, **kwargs, &block).to(value_mock) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::SetFeatureStubbedEntry, :call)
            .with_arguments(feature: feature_class, entry: entry_name, arguments: arguments, value: value)
        end
      end

      context "when used with `without_arguments`" do
        let(:arguments) { ConvenientService::Support::Arguments.null_arguments }

        specify do
          expect { helper.without_arguments.to(value_mock) }
            .to delegate_to(value_mock, :for)
            .with_arguments(feature_class, entry_name, arguments)
        end

        specify do
          expect { helper.without_arguments.to(value_mock) }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::SetFeatureStubbedEntry, :call)
            .with_arguments(feature: feature_class, entry: entry_name, arguments: arguments, value: value)
        end
      end
    end

    describe "#to_return_value" do
      let(:value) { :foo }

      specify do
        expect { helper.to_return_value(value) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock, :new)
          .with_arguments(value: value, feature_class: feature_class, entry_name: entry_name, arguments: arguments)
          .and_return_its_value
      end

      it "sets value mock for feature stub" do
        helper.to_return_value(value)

        expect(helper).not_to eq(described_class.new(feature_class: feature_class, entry_name: entry_name))
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

        context "when `other` has different `value_mock`" do
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
