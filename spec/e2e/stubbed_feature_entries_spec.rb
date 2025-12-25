# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Stubbed service results", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Helpers::StubEntry

  example_group "Feature" do
    example_group "class methods" do
      describe "some entry" do
        example_group "arguments" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config

              entry :main

              def main(*args, **kwargs, &block)
                :value_from_main_entry
              end
            end
          end

          let(:args) { [:foo] }
          let(:kwargs) { {foo: :bar} }
          let(:block) { proc { :foo } }

          let(:other_args) { [:bar] }
          let(:other_kwargs) { {bar: :baz} }
          let(:other_block) { proc { :bar } }

          context "when NO stubs" do
            specify { expect(feature_class.main).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
            specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }
          end

          context "when one stub" do
            context "when first stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub without arguments" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
            end
          end

          context "when multiple stubs" do
            context "when first stub with default (any arguments), second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub without arguments" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with default (any arguments), second stub with args" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }

              specify { expect(feature_class.main(*other_args)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }

              specify { expect(feature_class.main(**other_kwargs)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with block" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }

              specify { expect(feature_class.main(&other_block)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub without arguments, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub without arguments, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }
            end

            context "when first stub without arguments, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub without arguments, second stub with args" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub without arguments, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub without arguments, second stub with block" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with any arguments, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with any arguments, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }

              specify { expect(feature_class.main(*other_args)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }

              specify { expect(feature_class.main(**other_kwargs)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }

              specify { expect(feature_class.main(&other_block)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with args, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }

              specify { expect(feature_class.main(*other_args)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with args, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with args, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }

              specify { expect(feature_class.main(*other_args)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with args, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with args, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with args, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }

              specify { expect(feature_class.main(**other_kwargs)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with kwargs, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }

              specify { expect(feature_class.main(**other_kwargs)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with kwargs, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }

              specify { expect(feature_class.main(&other_block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with block, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_class.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }

              specify { expect(feature_class.main(&other_block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with block, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_class.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_class.main).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_class.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_class.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_class.main(&other_block)).to eq(:value_from_main_entry) }
            end
          end
        end

        example_group "comparison" do
          let(:klass) do
            Class.new do
              attr_reader :id

              def initialize(id)
                @id = id
              end

              def ==(other)
                return unless other.instance_of?(self.class)

                id == other.id
              end

              def ===(other)
                raise "Comparison by `===`"
              end

              def eql?(other)
                raise "Comparison by `eql?`"
              end

              def equal?(other)
                raise "Comparison by `equal?`"
              end
            end
          end

          let(:foo) { klass.new(:foo) }
          let(:bar) { klass.new(:bar) }
          let(:baz) { klass.new(:baz) }

          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config

              entry :main

              def main(*args, **kwargs, &block)
                :value_from_main_entry
              end
            end
          end

          let(:args) { [foo] }
          let(:kwargs) { {foo => bar} }
          let(:block) { proc { foo } }

          let(:other_args) { [bar] }
          let(:other_kwargs) { {bar => baz} }
          let(:other_block) { proc { bar } }

          before do
            stub_entry(feature_class, :main).without_arguments.to return_value("from first stub without arguments")
            stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stub with args")
            stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from third stub with kwargs")
            stub_entry(feature_class, :main).with_arguments(&block).to return_value("from fourth stub with block")
          end

          specify { expect(feature_class.main).to eq("from first stub without arguments") }
          specify { expect(feature_class.main(*args)).to eq("from second stub with args") }
          specify { expect(feature_class.main(**kwargs)).to eq("from third stub with kwargs") }
          specify { expect(feature_class.main(&block)).to eq("from fourth stub with block") }
        end
      end
    end

    example_group "instance methods" do
      describe "some entry" do
        example_group "arguments" do
          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config

              entry :main

              def main(*args, **kwargs, &block)
                :value_from_main_entry
              end
            end
          end

          let(:feature_instance) { feature_class.new }

          let(:args) { [:foo] }
          let(:kwargs) { {foo: :bar} }
          let(:block) { proc { :foo } }

          let(:other_args) { [:bar] }
          let(:other_kwargs) { {bar: :baz} }
          let(:other_block) { proc { :bar } }

          context "when NO stubs" do
            specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
            specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }
          end

          context "when one stub" do
            context "when first stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub without arguments" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
            end
          end

          context "when multiple stubs" do
            context "when first stub with default (any arguments), second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub without arguments" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with default (any arguments), second stub with args" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }

              specify { expect(feature_instance.main(*other_args)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }

              specify { expect(feature_instance.main(**other_kwargs)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with block" do
              before do
                stub_entry(feature_class, :main).to return_value("from first stubbed entry with default (any arguments)")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with default (any arguments)") }

              specify { expect(feature_instance.main(&other_block)).to eq("from first stubbed entry with default (any arguments)") }
            end

            context "when first stub without arguments, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub without arguments, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }
            end

            context "when first stub without arguments, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub without arguments, second stub with args" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub without arguments, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub without arguments, second stub with block" do
              before do
                stub_entry(feature_class, :main).without_arguments.to return_value("from first stubbed entry without arguments")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with any arguments, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with any arguments, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }

              specify { expect(feature_instance.main(*other_args)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }

              specify { expect(feature_instance.main(**other_kwargs)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with any arguments, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from first stubbed entry with any arguments")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from first stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from first stubbed entry with any arguments") }

              specify { expect(feature_instance.main(&other_block)).to eq("from first stubbed entry with any arguments") }
            end

            context "when first stub with args, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }

              specify { expect(feature_instance.main(*other_args)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with args, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with args, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }

              specify { expect(feature_instance.main(*other_args)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with args, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with args, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with args, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from first stubbed entry with args")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq("from first stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }

              specify { expect(feature_instance.main(**other_kwargs)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with kwargs, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }

              specify { expect(feature_instance.main(**other_kwargs)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with kwargs, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with kwargs, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from first stubbed entry with kwargs")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq("from first stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with default (any arguments)" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).to return_value("from second stubbed entry with default (any arguments)")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with default (any arguments)") }

              specify { expect(feature_instance.main(&other_block)).to eq("from second stubbed entry with default (any arguments)") }
            end

            context "when first stub with block, second stub without arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).without_arguments.to return_value("from second stubbed entry without arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry without arguments") }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with any arguments" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_any_arguments.to return_value("from second stubbed entry with any arguments")
              end

              specify { expect(feature_instance.main).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq("from second stubbed entry with any arguments") }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq("from second stubbed entry with any arguments") }

              specify { expect(feature_instance.main(&other_block)).to eq("from second stubbed entry with any arguments") }
            end

            context "when first stub with block, second stub with args" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stubbed entry with args")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq("from second stubbed entry with args") }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*other_args)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with kwargs" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from second stubbed entry with kwargs")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq("from second stubbed entry with kwargs") }
              specify { expect(feature_instance.main(&block)).to eq("from first stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**other_kwargs)).to eq(:value_from_main_entry) }
            end

            context "when first stub with block, second stub with block" do
              before do
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from first stubbed entry with block")
                stub_entry(feature_class, :main).with_arguments(&block).to return_value("from second stubbed entry with block")
              end

              specify { expect(feature_instance.main).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(&block)).to eq("from second stubbed entry with block") }
              specify { expect(feature_instance.main(*args, **kwargs)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(**kwargs, &block)).to eq(:value_from_main_entry) }
              specify { expect(feature_instance.main(*args, **kwargs, &block)).to eq(:value_from_main_entry) }

              specify { expect(feature_instance.main(&other_block)).to eq(:value_from_main_entry) }
            end
          end
        end

        example_group "comparison" do
          let(:klass) do
            Class.new do
              attr_reader :id

              def initialize(id)
                @id = id
              end

              def ==(other)
                return unless other.instance_of?(self.class)

                id == other.id
              end

              def ===(other)
                raise "Comparison by `===`"
              end

              def eql?(other)
                raise "Comparison by `eql?`"
              end

              def equal?(other)
                raise "Comparison by `equal?`"
              end
            end
          end

          let(:foo) { klass.new(:foo) }
          let(:bar) { klass.new(:bar) }
          let(:baz) { klass.new(:baz) }

          let(:feature_class) do
            Class.new do
              include ConvenientService::Feature::Standard::Config

              entry :main

              def main(*args, **kwargs, &block)
                :value_from_main_entry
              end
            end
          end

          let(:feature_instance) { feature_class.new }

          let(:args) { [foo] }
          let(:kwargs) { {foo => bar} }
          let(:block) { proc { foo } }

          let(:other_args) { [bar] }
          let(:other_kwargs) { {bar => baz} }
          let(:other_block) { proc { bar } }

          before do
            stub_entry(feature_class, :main).without_arguments.to return_value("from first stub without arguments")
            stub_entry(feature_class, :main).with_arguments(*args).to return_value("from second stub with args")
            stub_entry(feature_class, :main).with_arguments(**kwargs).to return_value("from third stub with kwargs")
            stub_entry(feature_class, :main).with_arguments(&block).to return_value("from fourth stub with block")
          end

          specify { expect(feature_instance.main).to eq("from first stub without arguments") }
          specify { expect(feature_instance.main(*args)).to eq("from second stub with args") }
          specify { expect(feature_instance.main(**kwargs)).to eq("from third stub with kwargs") }
          specify { expect(feature_instance.main(&block)).to eq("from fourth stub with block") }
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
