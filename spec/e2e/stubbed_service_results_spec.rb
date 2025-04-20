# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Stubbed service results", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Helpers::StubService

  include ConvenientService::RSpec::Matchers::Results

  example_group "Service" do
    example_group "class methods" do
      describe ".result" do
        example_group "arguments" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize(*args, **kwargs, &block)
              end

              def result
                success(from: "original result")
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
            specify { expect(service_class.result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
            specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }
          end

          context "when one stub" do
            context "when first stub with default (any arguments)" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub without arguments" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with any arguments" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with args" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
            end
          end

          context "when multiple stubs" do
            context "when first stub with default (any arguments), second stub with default (any arguments)" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub without arguments" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with any arguments" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with default (any arguments), second stub with args" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }

              specify { expect(service_class.result(*other_args)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with kwargs" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }

              specify { expect(service_class.result(**other_kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with block" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }

              specify { expect(service_class.result(&other_block)).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub without arguments, second stub with default (any arguments)" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub without arguments, second stub without arguments" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }
            end

            context "when first stub without arguments, second stub with any arguments" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub without arguments, second stub with args" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
            end

            context "when first stub without arguments, second stub with kwargs" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
            end

            context "when first stub without arguments, second stub with block" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with any arguments, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with any arguments, second stub without arguments" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with any arguments" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with args" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }

              specify { expect(service_class.result(*other_args)).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with kwargs" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }

              specify { expect(service_class.result(**other_kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with block" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from first stubbed result with any arguments") }

              specify { expect(service_class.result(&other_block)).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with args, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }

              specify { expect(service_class.result(*other_args)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with args, second stub without arguments" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with args, second stub with any arguments" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }

              specify { expect(service_class.result(*other_args)).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with args, second stub with args" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with args, second stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with args, second stub with block" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }

              specify { expect(service_class.result(**other_kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with kwargs, second stub without arguments" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with any arguments" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }

              specify { expect(service_class.result(**other_kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with kwargs, second stub with args" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with block" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(**other_kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }

              specify { expect(service_class.result(&other_block)).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with block, second stub without arguments" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with any arguments" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(**kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_failure.with_message("from second stubbed result with any arguments") }

              specify { expect(service_class.result(&other_block)).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with block, second stub with args" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*other_args)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&other_kwargs)).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with block" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(&block)).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.result(*args, *kwargs)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(**kwargs, &block)).to be_success.with_data(from: "original result") }
              specify { expect(service_class.result(*args, **kwargs, &block)).to be_success.with_data(from: "original result") }

              specify { expect(service_class.result(&other_block)).to be_success.with_data(from: "original result") }
            end
          end
        end

        example_group "comparion" do
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

          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize(*args, **kwargs, &block)
              end

              def result
                success(from: "original result")
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
            stub_service(service_class).without_arguments.to return_failure.with_message("from first stub without arguments")
            stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stub with args")
            stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from third stub with kwargs")
            stub_service(service_class).with_arguments(&block).to return_failure.with_message("from fourth stub with block")
          end

          specify { expect(service_class.result).to be_failure.with_message("from first stub without arguments") }
          specify { expect(service_class.result(*args)).to be_failure.with_message("from second stub with args") }
          specify { expect(service_class.result(**kwargs)).to be_failure.with_message("from third stub with kwargs") }
          specify { expect(service_class.result(&block)).to be_failure.with_message("from fourth stub with block") }
        end
      end
    end

    example_group "instance methods" do
      describe "#result" do
        example_group "arguments" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize(*args, **kwargs, &block)
              end

              def result
                success(from: "original result")
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
            specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
            specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }
          end

          context "when one stub" do
            context "when first stub with default (any arguments)" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub without arguments" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with any arguments" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with args" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
            end
          end

          context "when multiple stubs" do
            context "when first stub with default (any arguments), second stub with default (any arguments)" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub without arguments" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with any arguments" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with default (any arguments), second stub with args" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }

              specify { expect(service_class.new(*other_args).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with kwargs" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }

              specify { expect(service_class.new(**other_kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub with default (any arguments), second stub with block" do
              before do
                stub_service(service_class).to return_failure.with_message("from first stubbed result with default (any arguments)")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }

              specify { expect(service_class.new(&other_block).result).to be_failure.with_message("from first stubbed result with default (any arguments)") }
            end

            context "when first stub without arguments, second stub with default (any arguments)" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub without arguments, second stub without arguments" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub without arguments, second stub with any arguments" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub without arguments, second stub with args" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub without arguments, second stub with kwargs" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub without arguments, second stub with block" do
              before do
                stub_service(service_class).without_arguments.to return_failure.with_message("from first stubbed result without arguments")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with any arguments, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with any arguments, second stub without arguments" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with any arguments" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with args" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }

              specify { expect(service_class.new(*other_args).result).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with kwargs" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }

              specify { expect(service_class.new(**other_kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with any arguments, second stub with block" do
              before do
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from first stubbed result with any arguments")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from first stubbed result with any arguments") }

              specify { expect(service_class.new(&other_block).result).to be_failure.with_message("from first stubbed result with any arguments") }
            end

            context "when first stub with args, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }

              specify { expect(service_class.new(*other_args).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with args, second stub without arguments" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with args, second stub with any arguments" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }

              specify { expect(service_class.new(*other_args).result).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with args, second stub with args" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with args, second stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with args, second stub with block" do
              before do
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from first stubbed result with args")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from first stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }

              specify { expect(service_class.new(**other_kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with kwargs, second stub without arguments" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with any arguments" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }

              specify { expect(service_class.new(**other_kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with kwargs, second stub with args" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with kwargs, second stub with block" do
              before do
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from first stubbed result with kwargs")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from first stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(**other_kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with default (any arguments)" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).to return_failure.with_message("from second stubbed result with default (any arguments)")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }

              specify { expect(service_class.new(&other_block).result).to be_failure.with_message("from second stubbed result with default (any arguments)") }
            end

            context "when first stub with block, second stub without arguments" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).without_arguments.to return_failure.with_message("from second stubbed result without arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result without arguments") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with any arguments" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_any_arguments.to return_failure.with_message("from second stubbed result with any arguments")
              end

              specify { expect(service_class.new.result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_failure.with_message("from second stubbed result with any arguments") }

              specify { expect(service_class.new(&other_block).result).to be_failure.with_message("from second stubbed result with any arguments") }
            end

            context "when first stub with block, second stub with args" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stubbed result with args")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stubbed result with args") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*other_args).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with kwargs" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from second stubbed result with kwargs")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from second stubbed result with kwargs") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from first stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&other_kwargs).result).to be_success.with_data(from: "original result") }
            end

            context "when first stub with block, second stub with block" do
              before do
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from first stubbed result with block")
                stub_service(service_class).with_arguments(&block).to return_failure.with_message("from second stubbed result with block")
              end

              specify { expect(service_class.new.result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(&block).result).to be_failure.with_message("from second stubbed result with block") }
              specify { expect(service_class.new(*args, *kwargs).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(**kwargs, &block).result).to be_success.with_data(from: "original result") }
              specify { expect(service_class.new(*args, **kwargs, &block).result).to be_success.with_data(from: "original result") }

              specify { expect(service_class.new(&other_block).result).to be_success.with_data(from: "original result") }
            end
          end
        end

        example_group "comparion" do
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

          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def initialize(*args, **kwargs, &block)
              end

              def result
                success(from: "original result")
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
            stub_service(service_class).without_arguments.to return_failure.with_message("from first stub without arguments")
            stub_service(service_class).with_arguments(*args).to return_failure.with_message("from second stub with args")
            stub_service(service_class).with_arguments(**kwargs).to return_failure.with_message("from third stub with kwargs")
            stub_service(service_class).with_arguments(&block).to return_failure.with_message("from fourth stub with block")
          end

          specify { expect(service_class.new.result).to be_failure.with_message("from first stub without arguments") }
          specify { expect(service_class.new(*args).result).to be_failure.with_message("from second stub with args") }
          specify { expect(service_class.new(**kwargs).result).to be_failure.with_message("from third stub with kwargs") }
          specify { expect(service_class.new(&block).result).to be_failure.with_message("from fourth stub with block") }
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
