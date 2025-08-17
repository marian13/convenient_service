# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Base, type: :standard do
  let(:factory) { described_class.new(other: factory_other) }
  let(:factory_other) { :foo }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
  end

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { factory }

      it { is_expected.to have_attr_reader(:other) }
    end

    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { factory }

      it { is_expected.to have_abstract_method(:create_key) }
      it { is_expected.to have_abstract_method(:create_name) }
      it { is_expected.to have_abstract_method(:create_caller) }
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(factory == other).to be_nil
          end
        end

        context "when `other` has different `other`" do
          let(:other) { described_class.new(other: :bar) }

          it "returns `false`" do
            expect(factory == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(other: :foo) }

          it "returns `true`" do
            expect(factory == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
