# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromException::Concern, type: :standard do
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
    describe "#from_unhandled_exception?" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config.with(:fault_tolerance)

          def result
            success
          end
        end
      end

      context "when result is NOT created from unhandled exception`" do
        it "returns `false`" do
          expect(result.from_unhandled_exception?).to be(false)
        end
      end

      context "when result is created from unhandled exception" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config.with(:fault_tolerance)

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            end
          end
        end

        it "returns `true`" do
          expect(result.from_unhandled_exception?).to be(true)
        end
      end
    end

    describe "#unhandled_exception" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config.with(:fault_tolerance)

          def result
            success
          end
        end
      end

      context "when result is NOT created from unhandled exception" do
        it "returns `nil`" do
          expect(result.unhandled_exception).to be_nil
        end
      end

      context "when result is created from unhandled exception" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config.with(:fault_tolerance)

            def result
              raise ZeroDivisionError, "exception message", caller.take(5)
            end
          end
        end

        let(:exception) { service.new.result.unsafe_data[:unhandled_exception] }

        it "returns exception" do
          expect(result.unhandled_exception).to eq(exception)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
