# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Helpers::IgnoringException

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
    describe "#from_handled_exception?" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      context "when result is NOT created from handled exception`" do
        it "returns `false`" do
          expect(result.from_handled_exception?).to be(false)
        end
      end

      context "when result is created from handled exception" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            rescue => exception
              error_from_exception(exception)
            end
          end
        end

        it "returns `true`" do
          expect(result.from_handled_exception?).to be(true)
        end
      end
    end

    describe "#handled_exception" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      context "when result is NOT created from handled exception" do
        it "returns `nil`" do
          expect(result.handled_exception).to be_nil
        end
      end

      context "when result is created from handled exception" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            rescue => exception
              error_from_exception(exception)
            end
          end
        end

        let(:exception) { service.new.result.unsafe_data[:handled_exception] }

        it "returns exception" do
          expect(result.handled_exception).to eq(exception)
        end
      end
    end

    describe "#from_exception" do
      include ConvenientService::RSpec::Matchers::Results

      let(:result) { service.result }
      let(:exception) { service.new.result.unsafe_data[:handled_exception] }

      context "when result status is error" do
        context "when that error result does NOT have default data" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception message", caller.take(5)
              rescue => exception
                error(data: {foo: :bar}).from_exception(exception)
              end
            end
          end

          it "returns error result from exception with that NOT default data" do
            expect(result).to be_error.with_data(foo: :bar)
          end
        end

        context "when that error result has default data" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception message", caller.take(5)
              rescue => exception
                error.from_exception(exception)
              end
            end
          end

          it "returns error result from exception with handled exception data" do
            expect(result).to be_error.with_data(handled_exception: be_instance_of(ZeroDivisionError)).comparing_by(:===)
          end
        end

        context "when that error result does NOT have default message" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception message", caller.take(5)
              rescue => exception
                error(message: "foo").from_exception(exception)
              end
            end
          end

          it "returns error result from exception with that NOT default message" do
            expect(result).to be_error.with_message("foo")
          end
        end

        context "when that error result has default message" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception message", caller.take(5)
              rescue => exception
                error.from_exception(exception, max_backtrace_size: ConvenientService::Service::Plugins::CanHaveFormattedExceptions.default_max_backtrace_size + 5)
              end
            end
          end

          it "returns error result from exception with handled exception message" do
            expect(result).to be_error.with_message(ConvenientService::Service::Plugins::CanHaveFormattedExceptions.format_exception(exception))
          end

          context "when `max_backtrace_size` is passed" do
            specify do
              expect { result }
                .to delegate_to(ConvenientService::Service::Plugins::CanHaveFormattedExceptions, :format_exception)
                .with_arguments(exception, max_backtrace_size: ConvenientService::Service::Plugins::CanHaveFormattedExceptions.default_max_backtrace_size + 5)
            end
          end
        end

        context "when that error result does NOT have default code" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception message", caller.take(5)
              rescue => exception
                error(code: :foo).from_exception(exception)
              end
            end
          end

          it "returns error result from exception with that NOT default code" do
            expect(result).to be_error.with_code(:foo)
          end
        end

        context "when that error result has default code" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config

              def result
                raise ZeroDivisionError, "exception message", caller.take(5)
              rescue => exception
                error.from_exception(exception)
              end
            end
          end

          it "returns error result from exception with handled exception code" do
            expect(result).to be_error.with_code(:handled_exception)
          end
        end
      end

      context "when result status is failure" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            rescue => exception
              failure.from_exception(exception)
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            `failure(...).from_exception(exception, ...)` is NOT allowed. Only `error` results can be from exceptions.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Exceptions::FromExceptionOnNotErrorResult`" do
          expect { result }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Exceptions::FromExceptionOnNotErrorResult)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Exceptions::FromExceptionOnNotErrorResult) { result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when result status is success" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            rescue => exception
              success.from_exception(exception)
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            `success(...).from_exception(exception, ...)` is NOT allowed. Only `error` results can be from exceptions.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Exceptions::FromExceptionOnNotErrorResult`" do
          expect { result }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Exceptions::FromExceptionOnNotErrorResult)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromHandledException::Exceptions::FromExceptionOnNotErrorResult) { result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
