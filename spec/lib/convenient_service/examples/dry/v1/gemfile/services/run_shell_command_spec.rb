# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::V1::Gemfile::Services::RunShellCommand, type: :dry do
  include ConvenientService::RSpec::Helpers::StubService

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::V1::Gemfile::DryService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { service.result }

      let(:service) { described_class.new(command: command, debug: debug) }
      let(:command) { "ls -a" }
      let(:debug) { true }

      context "when `RunShellCommand` is NOT successful" do
        context "when command is NOT present" do
          let(:command) { "" }

          it "returns `failure` with `data`" do
            expect(result).to be_failure.with_data(command: "must be filled").of_service(described_class).without_step
          end
        end

        context "when command has non-zero code" do
          before do
            ##
            # Stubs private method Kernel#system.
            # https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-system
            #
            # NOTE: Do not stub private methods in RSpec unless you have a strong reason.
            # This particular case prevent shell commands execution.
            #
            allow(service).to receive(:system).with(command).and_return(false)
          end

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("#{command} returned non-zero exit code").of_service(described_class).of_step(:result)
          end
        end
      end

      context "when `RunShellCommand` is successful" do
        before do
          ##
          # Stubs private method Kernel#system.
          # https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-system
          #
          # NOTE: Do not stub private methods in RSpec unless you have a strong reason.
          # This particular case prevent shell commands execution.
          #
          allow(service).to receive(:system).with(command).and_return(true)
        end

        it "returns `success`" do
          expect(result).to be_success.without_data.of_service(described_class).of_step(:result)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
