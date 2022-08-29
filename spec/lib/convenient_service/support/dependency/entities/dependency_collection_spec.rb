# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Dependency::Entities::DependencyCollection do
  let(:dependency_collection) { described_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(Enumerable) }
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { dependency_collection }

      it { is_expected.to have_attr_reader(:dependencies) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when results have different classes" do
          let(:other) { 42 }

          it "returns `nil'" do
            expect(dependency_collection == other).to eq(nil)
          end
        end

        context "when dependency collections have different dependencies" do
          let(:other) { described_class.new.tap { |collection| collection << ConvenientService::Support::Dependency::Entities::Dependency.new(:bar, from: Class.new) } }

          it "returns `false'" do
            expect(dependency_collection == other).to eq(false)
          end
        end

        context "when dependency collections have same attributes" do
          let(:other) { described_class.new }

          it "returns `true'" do
            expect(dependency_collection == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
