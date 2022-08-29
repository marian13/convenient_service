# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Name do
  let(:name) { described_class.new(:foo) }
  let(:value) { :foo }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { name }

      it { is_expected.to have_attr_reader(:value) }
    end

    example_group "delegators" do
      include Shoulda::Matchers::Independent

      subject { name }

      it { is_expected.to delegate_method(:to_s).to(:value) }
      it { is_expected.to delegate_method(:to_sym).to(:value) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other' has different class" do
          let(:other) { 42 }

          it "returns `false'" do
            expect(name == other).to be_nil
          end
        end

        context "when `other' has different values" do
          let(:other) { described_class.new(:bar) }

          it "returns `false'" do
            expect(name == other).to eq(false)
          end
        end

        context "when `other' has same attributes" do
          let(:other) { described_class.new(:foo) }

          it "returns `true'" do
            expect(name == other).to eq(true)
          end
        end
      end
    end

    describe "#to_args" do
      let(:args_representation) { [value] }

      it "returns args representation of name" do
        expect(name.to_args).to eq(args_representation)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
