# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAwesomePrintInspect::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { message_class }

      let(:message_class) do
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
    describe "#inspect" do
      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Essential

          include ConvenientService::Service::Configs::AwesomePrintInspect

          def result
            error(message: "foo")
          end
        end
      end

      let(:message) { service.result.message }

      let(:keywords) { ["ConvenientService", "entity", "Message", "result", message.result.class.name, "text", "foo"] }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        message.class.commit_config!
      end

      it "returns `inspect` representation of message" do
        expect(message.inspect).to include(*keywords)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
