# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeStrict::Concern, type: :standard do
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
    describe "#strict?" do
      context "when result is NOT strict" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:result) { service.result }

        it "returns `false`" do
          expect(result.strict?).to be(false)
        end
      end

      context "when result is strict" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end
          end
        end

        let(:result) { service.result.strict }

        it "returns `true`" do
          expect(result.strict?).to be(true)
        end
      end
    end

    describe "#strict" do
      let(:result) { service.result }

      context "when result has success status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        it "returns original result" do
          expect(result.strict).to eq(result)
        end

        it "returns NOT strict result" do
          expect(result.strict.strict?).to be(false)
        end
      end

      context "when result has failure status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure
            end
          end
        end

        it "returns result copy with error status" do
          expect(result.strict).to eq(result.copy(overrides: {kwargs: {status: :error}}))
        end

        it "returns strict result" do
          expect(result.strict.strict?).to be(true)
        end
      end

      context "when result has error status" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error
            end
          end
        end

        it "returns original result" do
          expect(result.strict).to eq(result)
        end

        it "returns NOT strict result" do
          expect(result.strict.strict?).to be(false)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
