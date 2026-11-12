# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#to_h" do
      let(:result) { service_class.result }

      context "when result `status` is `:success`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(data: {foo: :bar, baz: :qux}, message: "foo", code: :foo)
            end
          end
        end

        let(:hash) do
          {
            status: :success,
            data: {foo: :bar, baz: :qux},
            message: "foo",
            code: :foo
          }
        end

        it "returns hash representation" do
          expect(result.to_h).to eq(hash)
        end

        context "when result has NO `data`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(message: "foo", code: :foo)
              end
            end
          end

          let(:hash) do
            {
              status: :success,
              data: {},
              message: "foo",
              code: :foo
            }
          end

          it "returns hash representation with default `data`" do
            expect(result.to_h).to eq(hash)
          end
        end

        context "when result has NO `message`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(data: {foo: :bar, baz: :qux}, code: :foo)
              end
            end
          end

          let(:hash) do
            {
              status: :success,
              data: {foo: :bar, baz: :qux},
              message: "",
              code: :foo
            }
          end

          it "returns hash representation with default `message`" do
            expect(result.to_h).to eq(hash)
          end
        end

        context "when result has NO `code`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(data: {foo: :bar, baz: :qux}, message: "foo")
              end
            end
          end

          let(:hash) do
            {
              status: :success,
              data: {foo: :bar, baz: :qux},
              message: "foo",
              code: :default_success
            }
          end

          it "returns hash representation with default `code`" do
            expect(result.to_h).to eq(hash)
          end
        end
      end

      context "when result `status` is `:failure`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure(data: {foo: :bar, baz: :qux}, message: "foo", code: :foo)
            end
          end
        end

        let(:hash) do
          {
            status: :failure,
            data: {foo: :bar, baz: :qux},
            message: "foo",
            code: :foo
          }
        end

        it "returns hash representation" do
          expect(result.to_h).to eq(hash)
        end

        context "when result has NO `data`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(message: "foo", code: :foo)
              end
            end
          end

          let(:hash) do
            {
              status: :failure,
              data: {},
              message: "foo",
              code: :foo
            }
          end

          it "returns hash representation with default `data`" do
            expect(result.to_h).to eq(hash)
          end
        end

        context "when result has NO `message`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(data: {foo: :bar, baz: :qux}, code: :foo)
              end
            end
          end

          let(:hash) do
            {
              status: :failure,
              data: {foo: :bar, baz: :qux},
              message: "",
              code: :foo
            }
          end

          it "returns hash representation with default `message`" do
            expect(result.to_h).to eq(hash)
          end
        end

        context "when result has NO `code`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(data: {foo: :bar, baz: :qux}, message: "foo")
              end
            end
          end

          let(:hash) do
            {
              status: :failure,
              data: {foo: :bar, baz: :qux},
              message: "foo",
              code: :default_failure
            }
          end

          it "returns hash representation with default `code`" do
            expect(result.to_h).to eq(hash)
          end
        end
      end

      context "when result `status` is `:error`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error(data: {foo: :bar, baz: :qux}, message: "foo", code: :foo)
            end
          end
        end

        let(:hash) do
          {
            status: :error,
            data: {foo: :bar, baz: :qux},
            message: "foo",
            code: :foo
          }
        end

        it "returns hash representation" do
          expect(result.to_h).to eq(hash)
        end

        context "when result has NO `data`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(message: "foo", code: :foo)
              end
            end
          end

          let(:hash) do
            {
              status: :error,
              data: {},
              message: "foo",
              code: :foo
            }
          end

          it "returns hash representation with default `data`" do
            expect(result.to_h).to eq(hash)
          end
        end

        context "when result has NO `message`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(data: {foo: :bar, baz: :qux}, code: :foo)
              end
            end
          end

          let(:hash) do
            {
              status: :error,
              data: {foo: :bar, baz: :qux},
              message: "",
              code: :foo
            }
          end

          it "returns hash representation with default `message`" do
            expect(result.to_h).to eq(hash)
          end
        end

        context "when result has NO `code`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(data: {foo: :bar, baz: :qux}, message: "foo")
              end
            end
          end

          let(:hash) do
            {
              status: :error,
              data: {foo: :bar, baz: :qux},
              message: "foo",
              code: :default_error
            }
          end

          it "returns hash representation with default `code`" do
            expect(result.to_h).to eq(hash)
          end
        end
      end
    end

    describe "#to_s" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:result) { service_class.result }

      context "when `format` is NOT passed" do
        it "defaults to `:inspect`" do
          expect { result.to_s }
            .to delegate_to(result, :inspect)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when `format` is passed" do
        context "when `format` is NOT `:inspect`" do
          it "returns string in `Object#to_s` representation" do
            expect(result.to_s(format: :foo)).to match(/#<#<Class:.+?>:.+?>/)
          end
        end

        context "when `format` is `:inspect`" do
          it "returns string in `#inspect` representation" do
            expect { result.to_s(format: :inspect) }
              .to delegate_to(result, :inspect)
              .without_arguments
              .and_return_its_value
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
