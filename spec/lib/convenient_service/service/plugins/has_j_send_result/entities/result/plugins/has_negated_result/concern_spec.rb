# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasNegatedResult::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
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
    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::Results

    describe "#negated?" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      context "when result is NOT from `negated_result` method" do
        let(:result) { service.result }

        it "returns `false`" do
          expect(result.negated?).to be(false)
        end
      end

      context "when result is from `negated_result` method" do
        let(:result) { service.negated_result }

        it "returns `true`" do
          expect(result.negated?).to be(true)
        end
      end
    end

    describe "#negated_result" do
      let(:service_instance) { service_class.new }
      let(:result) { service_instance.result }

      context "when original result is `success`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        ##
        # NOTE: This check is needed to make sure that `negated_result` is reusing original `result` extra kwargs, like `step`, `parent`, etc.
        #
        specify do
          expect { result.negated_result }
            .to delegate_to(result, :copy)
        end

        it "returns `failure`" do
          expect(result.negated_result).to be_failure
        end

        it "returns `failure` with additional `message`" do
          expect(result.negated_result).to be_failure.with_message("Original `result` is `success`")
        end

        it "returns `failure` with negated `code`" do
          expect(result.negated_result).to be_failure.with_code("negated_#{ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_SUCCESS_CODE}")
        end

        it "returns `failure` with NOT checked status" do
          expect(result.negated_result.checked?).to be(false)
        end

        context "when that `success` has `data`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(data: {foo: :bar})
              end
            end
          end

          it "returns `failure` with that `success` unmodified `data`" do
            expect(result.negated_result).to be_failure.with_data(service_instance.result.unsafe_data)
          end

          specify do
            expect { result.negated_result }
              .to delegate_to(service_instance.result, :unsafe_data)
              .without_arguments
          end
        end

        context "when that `success` has NOT empty `message`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(message: "foo")
              end
            end
          end

          it "returns `failure` with that `success` modified `message`" do
            expect(result.negated_result).to be_failure.with_message("Original `result` is `success` with `message` - #{service_instance.result.unsafe_message}")
          end

          specify do
            expect { result.negated_result }
              .to delegate_to(service_instance.result, :unsafe_message)
              .without_arguments
          end
        end

        context "when that `success` has `code`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                success(data: {code: :foo})
              end
            end
          end

          it "returns `failure` with that `success` negated `code`" do
            expect(result.negated_result).to be_failure.with_code("negated_#{service_instance.result.unsafe_code}")
          end

          specify do
            expect { result.negated_result }
              .to delegate_to(service_instance.result, :unsafe_code)
              .without_arguments
          end
        end
      end

      context "when original result is `failure`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end
          end
        end

        ##
        # NOTE: This check is needed to make sure that `negated_result` is reusing original `result` extra kwargs, like `step`, `parent`, etc.
        #
        specify do
          expect { result.negated_result }
            .to delegate_to(result, :copy)
        end

        it "returns `success`" do
          expect(result.negated_result).to be_success
        end

        it "returns `success` with additional `message`" do
          expect(result.negated_result).to be_success.with_message("Original `result` is `failure`")
        end

        it "returns `success` with negated `code`" do
          expect(result.negated_result).to be_success.with_code("negated_#{ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_CODE}")
        end

        it "returns `success` with NOT checked status" do
          expect(result.negated_result.checked?).to be(false)
        end

        context "when that `failure` has `data`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(data: {foo: :bar})
              end
            end
          end

          it "returns `success` with that `failure` unmodified `data`" do
            expect(result.negated_result).to be_success.with_data(service_instance.result.unsafe_data)
          end

          specify do
            expect { result.negated_result }
              .to delegate_to(service_instance.result, :unsafe_data)
              .without_arguments
          end
        end

        context "when that `failure` has NOT empty `message`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(message: "foo")
              end
            end
          end

          it "returns `success` with that `failure` modified `message`" do
            expect(result.negated_result).to be_success.with_message("Original `result` is `failure` with `message` - #{service_instance.result.unsafe_message}")
          end

          specify do
            expect { result.negated_result }
              .to delegate_to(service_instance.result, :unsafe_message)
              .without_arguments
          end
        end

        context "when that `failure` has `code`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                failure(code: :foo)
              end
            end
          end

          it "returns `success` with that `failure` negated `code`" do
            expect(result.negated_result).to be_success.with_code("negated_#{service_instance.result.unsafe_code}")
          end

          specify do
            expect { result.negated_result }
              .to delegate_to(service_instance.result, :unsafe_code)
              .without_arguments
          end
        end
      end

      context "when original result is `error`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        ##
        # NOTE: This check is needed to make sure that `negated_result` is reusing original `result` extra kwargs, like `step`, `parent`, etc.
        #
        specify do
          expect { result.negated_result }
            .to delegate_to(result, :copy)
        end

        it "returns copy of that original `error`" do
          expect(result.negated_result).to eq(service_instance.result.copy(overrides: {kwargs: {negated: true}}))
        end

        it "returns copy of that original `error` with original `message`" do
          expect(result.negated_result).to be_error.with_message(service_instance.result.unsafe_message)
        end

        it "returns copy of that original `error` with original `code`" do
          expect(result.negated_result).to be_error.with_code(service_instance.result.unsafe_code)
        end

        it "returns copy of that original `error` with NOT checked status" do
          expect(result.negated_result.checked?).to be(false)
        end

        context "when that original `error` has `data`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(data: {foo: :bar})
              end
            end
          end

          it "returns copy of that original `error` with its unmodified `data`" do
            expect(result.negated_result).to be_error.with_data(service_instance.result.unsafe_data)
          end
        end

        context "when that original `error` has NOT empty `message`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(message: "foo")
              end
            end
          end

          it "returns copy of that original `error` with its unmodified `message`" do
            expect(result.negated_result).to be_error.with_message(service_instance.result.unsafe_message)
          end
        end

        context "when that original `error` has `code`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                error(code: :foo)
              end
            end
          end

          it "returns copy of that original `error` with its unmodified `code`" do
            expect(result.negated_result).to be_error.with_code(service_instance.result.unsafe_code)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
