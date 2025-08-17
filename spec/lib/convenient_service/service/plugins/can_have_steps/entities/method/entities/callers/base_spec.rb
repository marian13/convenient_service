# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base, type: :standard do
  let(:caller) { described_class.new(value) }
  let(:value) { :foo }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    example_group "attributes" do
      include ConvenientService::RSpec::Matchers::HaveAttrReader

      subject { caller }

      it { is_expected.to have_attr_reader(:object) }
    end

    example_group "abstract methods" do
      include ConvenientService::RSpec::Matchers::HaveAbstractMethod

      subject { caller }

      it { is_expected.to have_abstract_method(:calculate_value) }
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

    describe "#usual?" do
      it "returns `false`" do
        expect(caller.usual?).to eq(false)
      end
    end

    describe "#alias?" do
      it "returns `false`" do
        expect(caller.alias?).to eq(false)
      end
    end

    describe "#proc?" do
      it "returns `false`" do
        expect(caller.proc?).to eq(false)
      end
    end

    describe "#raw?" do
      it "returns `false`" do
        expect(caller.raw?).to eq(false)
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(*args) }
      let(:args) { [value] }

      describe "#to_args" do
        specify do
          allow(caller).to receive(:to_arguments).and_return(arguments)

          expect { caller.to_args }
            .to delegate_to(caller.to_arguments, :args)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of caller" do
          expect(caller.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
