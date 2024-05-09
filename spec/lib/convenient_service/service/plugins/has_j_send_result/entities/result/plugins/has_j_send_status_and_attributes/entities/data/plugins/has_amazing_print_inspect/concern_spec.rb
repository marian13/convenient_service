# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAmazingPrintInspect::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { data_class }

      let(:data_class) do
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

          include ConvenientService::Service::Configs::AmazingPrintInspect

          def result
            success(data: {foo: +"bar"})
          end
        end
      end

      let(:data) { service.result.data }

      let(:keywords) { ["ConvenientService", "entity", "Data", "result", data.result.class.name, "values", ":foo", "bar"] }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        data.class.commit_config!
      end

      it "returns `inspect` representation of data" do
        expect(data.inspect).to include(*keywords)
      end

      specify do
        expect { data.inspect }
          .to delegate_to(data[:foo], :inspect)
          .without_arguments
      end

      context "when `data` has no values" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential

            include ConvenientService::Service::Configs::AmazingPrintInspect

            def result
              success
            end
          end
        end

        let(:keywords) { ["ConvenientService", "entity", "Data", "result", data.result.class.name, "values", "{}"] }

        it "returns `inspect` representation of data" do
          expect(data.inspect).to include(*keywords)
        end
      end

      ##
      # TODO: Specs.
      #
      # context "when `data` has value with long inspect respresentation" do
      #
      # end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
