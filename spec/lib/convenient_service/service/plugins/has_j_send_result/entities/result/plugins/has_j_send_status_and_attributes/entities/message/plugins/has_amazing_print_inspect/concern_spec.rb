# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::AmazingPrintInspect::Config

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAmazingPrintInspect::Concern, type: :amazing_print do
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
          include ConvenientService::Standard::Config.with(:amazing_print_inspect)

          def self.name
            "ImportantService"
          end

          def result
            error(message: "foo")
          end
        end
      end

      let(:message) { service.result.unsafe_message }

      let(:keywords) { ["ConvenientService", ":entity", "Message", ":result", "ImportantService::Result", ":text", "foo"] }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        message.class.commit_config!
      end

      it "returns `inspect` representation of message" do
        expect(message.inspect).to include(*keywords)
      end

      context "when service class is anonymous" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config.with(:amazing_print_inspect)

            def result
              error(message: "foo")
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Message", ":result", "AnonymousClass(##{service.object_id})::Result", ":text", "foo"] }

        it "uses custom class name" do
          expect(message.inspect).to include(*keywords)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
