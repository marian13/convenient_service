# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveStep::Concern do
  include ConvenientService::RSpec::Matchers::CacheItsValue

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
    describe "#step" do
      let(:result) { service.result }

      context "when result is NOT from step" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Standard

            def result
              success
            end
          end
        end

        it "returns `nil`" do
          expect(result.step).to be_nil
        end
      end

      context "when result is from step" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Service::Configs::Standard

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Service::Configs::Standard

            def result
              error
            end
          end
        end

        it "returns result step" do
          expect(result.step).to eq(service.step_class.new(first_step, container: service, organizer: result.service, index: 0))
        end

        specify do
          expect { result.step }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
