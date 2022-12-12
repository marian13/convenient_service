# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Module::FetchOwnConst do
  describe ".call" do
    let(:mod) { Class.new }

    let(:fallback_block) { proc { 42 } }

    context "when const is NOT defined directly inside module namespace" do
      context "when const is NOT defined at all" do
        let(:const_name) { :NotExistingConst }

        context "when `fallback_block` is NOT passed" do
          let(:result) { described_class.call(mod, const_name) }

          it "returns `nil`" do
            expect(result).to be_nil
          end
        end

        context "when `fallback_block` is passed" do
          let(:result) { described_class.call(mod, const_name, &fallback_block) }

          it "returns `fallback_block` value" do
            expect(result).to eq(fallback_block.call)
          end

          it "set own const to `fallback_block` value" do
            result

            expect(mod.const_get(const_name, false)).to eq(fallback_block.call)
          end
        end
      end

      context "when const is defined outside module namespace" do
        ##
        # NOTE: `File` is defined in `Object` class from Ruby Core.
        #
        let(:const_name) { :File }

        context "when `fallback_block` is NOT passed" do
          let(:result) { described_class.call(mod, const_name) }

          it "returns `nil`" do
            expect(result).to be_nil
          end
        end

        context "when `fallback_block` is passed" do
          let(:result) { described_class.call(mod, const_name, &fallback_block) }

          it "returns `fallback_block` value" do
            expect(result).to eq(fallback_block.call)
          end

          it "set own const to `fallback_block` value" do
            result

            expect(mod.const_get(const_name, false)).to eq(fallback_block.call)
          end
        end
      end
    end

    context "when const is defined directly inside module namespace" do
      let(:mod) do
        Class.new.tap do |klass|
          klass.const_set(:File, Class.new)
        end
      end

      let(:const_name) { :File }

      context "when `fallback_block` is NOT passed" do
        let(:result) { described_class.call(mod, const_name) }

        it "returns that const" do
          expect(result).to eq(mod::File)
        end
      end

      context "when `fallback_block` is passed" do
        let(:result) { described_class.call(mod, const_name, &fallback_block) }

        it "returns that const" do
          expect(result).to eq(mod::File)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
