# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeOwnResult::Concern, type: :standard do
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
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:other_service_instance) { service_class.new }
    let(:result) { service_instance.result }

    describe "#own_result_for?" do
      specify do
        expect { result.own_result_for?(service_instance) }
          .to delegate_to(result.service, :equal?)
          .with_arguments(service_instance)
          .and_return_its_value
      end

      context "when result is NOT own (is foreign) result" do
        it "returns `false`" do
          expect(result.own_result_for?(other_service_instance)).to eq(false)
        end
      end

      context "when result is own result" do
        it "returns `true`" do
          expect(result.own_result_for?(service_instance)).to eq(true)
        end
      end
    end

    describe "#foreign_result_for?" do
      specify do
        expect { result.foreign_result_for?(service_instance) }
          .to delegate_to(result, :own_result_for?)
          .with_arguments(service_instance)
      end

      context "when result is NOT foreign (is own) result" do
        it "returns `false`" do
          expect(result.foreign_result_for?(service_instance)).to eq(false)
        end
      end

      context "when result is foreign result" do
        it "returns `true`" do
          expect(result.foreign_result_for?(other_service_instance)).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
