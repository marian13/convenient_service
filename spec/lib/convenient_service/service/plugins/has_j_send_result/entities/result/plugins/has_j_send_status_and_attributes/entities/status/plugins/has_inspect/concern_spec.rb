# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { status_class }

      let(:status_class) do
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
          include ConvenientService::Standard::Config

          def self.name
            "ImportantService"
          end

          def result
            success
          end
        end
      end

      let(:status) { service.result.status }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        status.class.commit_config!
      end

      it "returns `inspect` representation of status" do
        expect(status.inspect).to eq("<ImportantService::Result::Status type: :#{status}>")
      end

      context "when service class is anonymous" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(data: {foo: "bar"})
            end
          end
        end

        it "uses custom class name" do
          expect(status.inspect).to eq("<AnonymousClass(##{service.object_id})::Result::Status type: :#{status}>")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
