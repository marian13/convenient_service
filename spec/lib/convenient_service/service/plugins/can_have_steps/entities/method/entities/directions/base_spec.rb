# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Base, type: :standard do
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

      it { is_expected.to have_abstract_method(:define_output_in_container!) }
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new }

      describe "#to_arguments" do
        it "returns arguments representation of direction" do
          expect(direction.to_arguments).to eq(arguments)
        end
      end
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
