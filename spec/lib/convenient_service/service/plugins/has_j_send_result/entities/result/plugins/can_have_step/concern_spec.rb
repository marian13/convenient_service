# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveStep::Concern, type: :standard do
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
    describe "#from_step?" do
      let(:result) { service.result }

      context "when result is NOT from step" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        it "returns `false`" do
          expect(result.from_step?).to be(false)
        end
      end

      context "when result is from step" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        it "returns `true`" do
          expect(result.from_step?).to be(true)
        end
      end
    end

    describe "#step" do
      let(:result) { service.result }

      context "when result is NOT from step" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        it "returns `nil`" do
          expect(result.step).to be_nil
        end

        specify do
          expect { result.step }.to cache_its_value
        end
      end

      context "when result is from step" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

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

    describe "#original_service" do
      let(:result) { service.result }

      context "when result is NOT from step" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        it "returns `service`" do
          expect(result.original_service).to eq(result.service)
        end

        specify do
          expect { result.original_service }.to cache_its_value
        end
      end

      context "when result is from step" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step

              def result
                success
              end
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        it "returns result original service from step" do
          expect(result.original_service).to be_instance_of(first_step)
        end

        specify do
          expect { result.original_service }.to cache_its_value
        end
      end

      context "when result is from nested step" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:first_step) do
          Class.new.tap do |klass|
            klass.class_exec(nested_step_of_first_step) do |nested_step_of_first_step|
              include ConvenientService::Standard::Config

              step nested_step_of_first_step
            end
          end
        end

        let(:nested_step_of_first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        it "returns result original service from nested step" do
          expect(result.original_service).to be_instance_of(nested_step_of_first_step)
        end

        specify do
          expect { result.original_service }.to cache_its_value
        end
      end

      context "when result is from deeply nested step" do
        let(:service) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        let(:first_step) do
          Class.new.tap do |klass|
            klass.class_exec(nested_step_of_first_step) do |nested_step_of_first_step|
              include ConvenientService::Standard::Config

              step nested_step_of_first_step
            end
          end
        end

        let(:nested_step_of_first_step) do
          Class.new.tap do |klass|
            klass.class_exec(double_nested_step_of_first_step) do |double_nested_step_of_first_step|
              include ConvenientService::Standard::Config

              step double_nested_step_of_first_step
            end
          end
        end

        let(:double_nested_step_of_first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        it "returns result original service from deeply nested step" do
          expect(result.original_service).to be_instance_of(double_nested_step_of_first_step)
        end

        specify do
          expect { result.original_service }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
