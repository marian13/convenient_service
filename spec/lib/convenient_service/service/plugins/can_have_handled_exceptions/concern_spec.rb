# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveHandledExceptions::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

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
    describe "#error_from_exception" do
      include ConvenientService::RSpec::Matchers::Results

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

      let(:result) { service.result }
      let(:exception) { result.unsafe_data[:handled_exception] }

      let(:formatted_message) { ConvenientService::Service::Plugins::CanHaveFormattedExceptions::format_exception(exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size) }
      let(:max_backtrace_size) { ConvenientService::Service::Plugins::CanHaveFormattedExceptions.default_max_backtrace_size }

      it "returns error result with data, message and code" do
        expect(result).to be_error.with_data(handled_exception: be_instance_of(ZeroDivisionError)).and_message(formatted_message).and_code(:handled_exception).comparing_by(:===)
      end

      it "returns error result from exception" do
        expect(result.from_exception?).to be(true)
      end

      it "returns error result from handled exception" do
        expect(result.from_handled_exception?).to be(true)
      end

      specify do
        expect { result.service.recalculate.result }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveFormattedExceptions, :default_max_backtrace_size)
          .without_arguments
      end

      context "when `fault_tolerance` option is enabled" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config.with(:fault_tolerance)

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            rescue => exception
              error_from_exception(exception)
            end
          end
        end

        it "returns error result from handled exception" do
          expect(result.from_unhandled_exception?).to be(false)
        end
      end

      context "when `max_backtrace_size` `error_from_exception` option is passed" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config.with(:fault_tolerance)

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            rescue => exception
              error_from_exception(exception, max_backtrace_size: 3)
            end
          end
        end

        specify do
          expect { result.service.recalculate.result }
            .to delegate_to(ConvenientService::Service::Plugins::CanHaveFormattedExceptions, :format_exception)
            .with_arguments(exception, max_backtrace_size: 3)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
