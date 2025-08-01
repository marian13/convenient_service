# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ObjectOrNil, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:step_aware_boolean) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { true }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAliasMethod

      subject { step_aware_boolean }

      it { is_expected.to have_alias_method(:object_or_nil, :object) }
    end

    describe "#result" do
      let(:result) { step_aware_boolean.result }

      context "when step aware object or nil does NOT have propagated result" do
        let(:propagated_result) { nil }

        context "when `object` is `nil`" do
          let(:object) { nil }

          it "returns failure result without data" do
            expect(result).to be_failure.without_data.of_service(service).without_step
          end

          context "when `data_key` is passed" do
            let(:result) { step_aware_boolean.result(data_key: data_key) }

            let(:data_key) { :element }

            it "is ignored (returns failure result without data)" do
              expect(result).to be_failure.without_data.of_service(service).without_step
            end
          end

          context "when `evaluate_by` is passed" do
            let(:result) { step_aware_boolean.result(evaluate_by: evaluate_by) }

            let(:evaluate_by) { :to_s }

            it "is NOT ignored (returns success result with data since nil was converted by `evaluate_by` to truthy object)" do
              expect(result).to be_success.with_data(value: object.to_s).of_service(service).without_step
            end
          end
        end

        context "when `object` is truthy object" do
          let(:object) { 42 }

          it "returns success result with data" do
            expect(result).to be_success.with_data(value: object).of_service(service).without_step
          end

          context "when `data_key` is passed" do
            let(:result) { step_aware_boolean.result(data_key: data_key) }

            let(:data_key) { :element }

            it "is NOT ignored (returns success result with data with different key)" do
              expect(result).to be_success.with_data(data_key => object).of_service(service).without_step
            end
          end

          context "when `evaluate_by` is passed" do
            let(:result) { step_aware_boolean.result(evaluate_by: evaluate_by) }

            let(:evaluate_by) { :to_s }

            it "is NOT ignored (returns success result with data with different value that was received from `evaluate` by conversion)" do
              expect(result).to be_success.with_data(value: object.to_s).of_service(service).without_step
            end
          end
        end
      end

      context "when step aware object or nil has propagated result" do
        let(:propagated_result) { service.error(code: "from propagated result") }

        it "returns that propagated result" do
          expect(result).to be_error.with_code("from propagated result").of_service(service).without_step
        end

        context "when that propagated result from different service" do
          let(:other_service) do
            Class.new do
              include ConvenientService::Standard::Config
            end
          end

          let(:other_organizer) { other_service.new }

          let(:propagated_result) { other_organizer.error(code: "from propagated result from different service") }

          it "returns that propagated result" do
            expect(result).to be_error.with_code("from propagated result from different service").of_service(other_service).without_step
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
