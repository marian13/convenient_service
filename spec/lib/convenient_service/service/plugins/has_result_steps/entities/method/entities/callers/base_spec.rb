# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Base do
  let(:caller) { described_class.new(value) }
  let(:value) { :foo }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { caller }

      it { is_expected.to have_attr_reader(:object) }
    end

    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { caller }

      it { is_expected.to have_abstract_method(:calculate_value) }
      it { is_expected.to have_abstract_method(:validate_as_input_for_container!) }
      it { is_expected.to have_abstract_method(:validate_as_output_for_container!) }
      it { is_expected.to have_abstract_method(:define_output_in_container!) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(caller == other).to be_nil
          end
        end

        context "when `other` has different `object`" do
          let(:other) { described_class.new(:bar) }

          it "returns `false`" do
            expect(caller == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(:foo) }

          it "returns `true`" do
            expect(caller == other).to eq(true)
          end
        end
      end
    end

    describe "#to_args" do
      let(:args_representation) { [value] }

      it "returns args representation of caller" do
        expect(caller.to_args).to eq(args_representation)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
