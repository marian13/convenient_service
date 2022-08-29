# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Dependency::Entities::Dependency do
  let(:dependency) { described_class.new(method, from: receiver) }

  let(:method) { :foo }
  let(:receiver) { Class.new }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { dependency }

      it { is_expected.to have_attr_reader(:method) }
      it { is_expected.to have_attr_reader(:receiver) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when results have different classes" do
          let(:other) { 42 }

          it "returns `nil'" do
            expect(dependency == other).to eq(nil)
          end
        end

        context "when dependencies have different methods" do
          let(:other) { described_class.new(:bar, from: receiver) }

          it "returns `false'" do
            expect(dependency == other).to eq(false)
          end
        end

        context "when dependencies have different receivers" do
          let(:other) { described_class.new(method, from: Class.new) }

          it "returns `false'" do
            expect(dependency == other).to eq(false)
          end
        end

        context "when dependencies have same attributes" do
          let(:other) { described_class.new(method, from: receiver) }

          it "returns `true'" do
            expect(dependency == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
