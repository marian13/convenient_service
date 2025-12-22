# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeStubbedResult::Concern, type: :standard do
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
    include ConvenientService::RSpec::Helpers::StubService

    describe "#stubbed_result?" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      context "when result is NOT created by `stub_service`" do
        it "returns `false`" do
          expect(result.stubbed_result?).to be(false)
        end
      end

      context "when result is created by `stub_service`" do
        before do
          stub_service(service).to return_error
        end

        it "returns `true`" do
          expect(result.stubbed_result?).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
