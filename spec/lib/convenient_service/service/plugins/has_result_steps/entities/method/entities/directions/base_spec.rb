# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Directions::Base do
  let(:direction) { described_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { direction }

      it { is_expected.to have_abstract_method(:validate_as_input_for_container!) }
      it { is_expected.to have_abstract_method(:validate_as_output_for_container!) }
      it { is_expected.to have_abstract_method(:define_output_in_container!) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(direction == other).to be_nil
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new }

          it "returns `true`" do
            expect(direction == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
