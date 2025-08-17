# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_aware_object) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { 42 }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base) }
  end

  example_group "instance methods" do
    describe "#default_data_key" do
      it "returns `:value`" do
        expect(step_aware_object.default_data_key).to eq(:value)
      end
    end

    describe "#default_evaluate_by" do
      it "returns `nil`" do
        expect(step_aware_object.default_evaluate_by).to be_nil
      end
    end

    describe "#respond_to_missing?" do
      let(:step_aware_klass) do
        Class.new(described_class) do
          def respond_to_missing_public?(...)
            respond_to_missing?(...)
          end
        end
      end

      let(:step_aware_object) { step_aware_klass.new(object: object, organizer: organizer, propagated_result: propagated_result) }

      let(:method) { :result }
      let(:include_private) { true }

      specify do
        expect { step_aware_object.respond_to_missing_public?(method, include_private) }
          .to delegate_to(step_aware_object, :respond_to?)
          .with_arguments(method, include_private)
          .and_return_its_value
      end

      context "when `include_private` is NOT passed" do
        it "defaults to `false`" do
          expect { step_aware_object.respond_to_missing_public?(method) }
            .to delegate_to(step_aware_object, :respond_to?)
            .with_arguments(method, false)
            .and_return_its_value
        end
      end
    end

    describe "#method_missing" do
      let(:exception_message) do
        <<~TEXT
          Step aware enumerable has already used a terminal chaining like `all?`, `any?`, `find`, `first`, etc.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::AlreadyUsedTerminalChaining`" do
        expect { step_aware_object.not_existing_method }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::AlreadyUsedTerminalChaining)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::AlreadyUsedTerminalChaining) { step_aware_object.not_existing_method } }
          .to delegate_to(ConvenientService, :raise)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
