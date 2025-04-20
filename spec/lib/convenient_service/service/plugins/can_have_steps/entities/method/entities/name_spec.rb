# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name, type: :standard do
  let(:name) { described_class.new(:foo) }
  let(:value) { :foo }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { name }

      it { is_expected.to have_attr_reader(:value) }
    end

    ##
    # NOTE: Waits for `should-matchers` full support.
    #
    # example_group "delegators" do
    #   include Shoulda::Matchers::Independent
    #
    #   subject { name }
    #
    #   it { is_expected.to delegate_method(:to_s).to(:value) }
    #   it { is_expected.to delegate_method(:to_sym).to(:value) }
    # end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(name == other).to be_nil
          end
        end

        context "when `other` has different values" do
          let(:other) { described_class.new(:bar) }

          it "returns `false`" do
            expect(name == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(:foo) }

          it "returns `true`" do
            expect(name == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(*args) }
      let(:args) { [value] }

      describe "#to_args" do
        specify do
          allow(name).to receive(:to_arguments).and_return(arguments)

          expect { name.to_args }
            .to delegate_to(name.to_arguments, :args)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of name" do
          expect(name.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
