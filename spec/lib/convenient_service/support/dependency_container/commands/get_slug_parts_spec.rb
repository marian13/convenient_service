# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::GetSlugParts do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(slug: slug) }

      context "when `slug` is valid" do
        context "when `slug` has namespaces separated by dot" do
          let(:slug) { "foo.bar.baz" }

          it "returns array of `slug` parts" do
            expect(command_result).to eq([:foo, :bar, :baz])
          end
        end

        context "when `slug` has namespaces separated by scope resolution operator" do
          let(:slug) { "qux::quux" }

          it "returns array of `slug` parts" do
            expect(command_result).to eq([:qux, :quux])
          end
        end

        context "when `slug` is NOT separated" do
          let(:slug) { "xyzzy" }

          it "returns array of `slug` parts" do
            expect(command_result).to eq([:xyzzy])
          end
        end
      end

      context "when `slug` is NOT valid" do
        let(:slug) { nil }

        it "returns empty array" do
          expect(command_result).to eq([])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
