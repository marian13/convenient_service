# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::RunShell do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrAccessor
  include ConvenientService::RSpec::Matchers::IncludeModule
  ##
  # NOTE: Waits for `should-matchers' full support.
  #
  # include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {command: command, debug: debug} }
  let(:command) { "ls -a" }
  let(:debug) { false }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsServiceConfig) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_accessor(:command) }
    it { is_expected.to have_attr_accessor(:debug) }
  end

  ##
  # NOTE: Waits for `should-matchers' full support.
  #
  # example_group "validations" do
  #   subject { service }
  #
  #   it { is_expected.to validate_presence_of(:command) }
  # end

  describe "#result" do
    subject(:result) { service.result }

    context "when shell command has non-zero code" do
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

      context "when debug is truthy" do
        let(:debug) { true }

        before do
          allow(ConvenientService::Examples::Rails::Gemfile::Services::PrintShellCommand).to receive(:result).with(hash_including(text: command))
        end

        it "prints command" do
          result

          expect(ConvenientService::Examples::Rails::Gemfile::Services::PrintShellCommand).to have_received(:result)
        end
      end

      it "returns error with message" do
        expect(result).to be_error.with_message("#{command} returned non-zero exit code")
      end
    end

    context "when shell command has zero code" do
      before do
        allow(service).to receive(:system).with(command).and_return(true)
      end

      it "returns success" do
        expect(result).to be_success
      end

      context "when debug is truthy" do
        let(:debug) { true }

        before do
          allow(ConvenientService::Examples::Rails::Gemfile::Services::PrintShellCommand).to receive(:result).with(hash_including(text: command))
        end

        it "prints command" do
          result

          expect(ConvenientService::Examples::Rails::Gemfile::Services::PrintShellCommand).to have_received(:result)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
