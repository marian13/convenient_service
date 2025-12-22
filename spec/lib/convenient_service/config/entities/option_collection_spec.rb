# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Config::Entities::OptionCollection, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:option_collection) { described_class.new(options: options) }

  let(:options) do
    {
      callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true),
      fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true),
      rollbacks: ConvenientService::Config::Entities::Option.new(name: :rollbacks, enabled: true)
    }
  end

  example_group "instance methods" do
    describe "#include?" do
      context "when `options` do NOT contain option with `key`" do
        let(:options) do
          {
            fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true)
          }
        end

        it "returns `false`" do
          expect(option_collection.include?(:callbacks)).to be(false)
        end
      end

      context "when `options` contain option with `key`" do
        let(:options) do
          {
            callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true)
          }
        end

        it "returns `true`" do
          expect(option_collection.include?(:callbacks)).to be(true)
        end
      end
    end

    describe "#enabled?" do
      context "when `options` do NOT contain option with `key`" do
        let(:options) do
          {
            fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true)
          }
        end

        it "returns `false`" do
          expect(option_collection.enabled?(:callbacks)).to be(false)
        end
      end

      context "when `options` contain option with `key`" do
        context "when `options` contain NOT enabled option with `key`" do
          let(:options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: false)
            }
          end

          it "returns `false`" do
            expect(option_collection.enabled?(:callbacks)).to be(false)
          end
        end

        context "when `options` contain enabled option with `key`" do
          let(:options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true)
            }
          end

          it "returns `true`" do
            expect(option_collection.enabled?(:callbacks)).to be(true)
          end
        end
      end
    end

    describe "#disabled?" do
      context "when `options` do NOT contain option with `key`" do
        let(:options) do
          {
            fallbacks: ConvenientService::Config::Entities::Option.new(name: :fallbacks, enabled: true)
          }
        end

        it "returns `true`" do
          expect(option_collection.disabled?(:callbacks)).to be(true)
        end
      end

      context "when `options` contain option with `key`" do
        context "when `options` contain NOT enabled option with `key`" do
          let(:options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: false)
            }
          end

          it "returns `true`" do
            expect(option_collection.disabled?(:callbacks)).to be(true)
          end
        end

        context "when `options` contain enabled option with `key`" do
          let(:options) do
            {
              callbacks: ConvenientService::Config::Entities::Option.new(name: :callbacks, enabled: true)
            }
          end

          it "returns `false`" do
            expect(option_collection.disabled?(:callbacks)).to be(false)
          end
        end
      end
    end

    describe "#keys" do
      specify do
        expect { option_collection.keys }
          .to delegate_to(options, :keys)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#[]" do
      let(:name) { :callbacks }

      specify do
        expect { option_collection[name] }
          .to delegate_to(options, :[])
          .with_arguments(name)
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(option_collection == other).to be_nil
          end
        end

        context "when `other` have different options" do
          let(:other) { described_class.new(options: {rspec: ConvenientService::Config::Entities::Option.new(name: :rspec, enabled: true)}) }

          it "returns `false`" do
            expect(option_collection == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(options: options) }

          it "returns `true`" do
            expect(option_collection == other).to be(true)
          end
        end
      end
    end

    describe "#to_a" do
      specify do
        expect { option_collection.to_a }
          .to delegate_to(options, :values)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#to_h" do
      it "returns `options` passed to constuctor" do
        expect(option_collection.to_h).to eq(options)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
