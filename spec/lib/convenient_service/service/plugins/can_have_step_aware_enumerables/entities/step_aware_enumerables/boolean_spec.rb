# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Boolean, type: :standard do
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
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::Matchers::HaveAliasMethod

      subject { step_aware_boolean }

      it { is_expected.to have_alias_method(:boolean, :object) }
    end

    describe "#result" do
      let(:result) { step_aware_boolean.result }

      context "when step aware boolean does NOT have propagated result" do
        let(:propagated_result) { nil }

        context "when `object` is `false`" do
          let(:object) { false }

          it "returns failure result without data" do
            expect(result).to be_failure.without_data.of_service(service).without_step
          end

          context "when `data_key` is passed" do
            let(:result) { step_aware_boolean.result(data_key: data_key) }

            let(:data_key) { :elements }

            it "is ignored" do
              expect(result).to be_failure.without_data.of_service(service).without_step
            end
          end

          context "when `evaluate_by` is passed" do
            let(:result) { step_aware_boolean.result(evaluate_by: evaluate_by) }

            let(:evaluate_by) { :to_s }

            it "is ignored" do
              expect(result).to be_failure.without_data.of_service(service).without_step
            end
          end
        end

        context "when `object` is `true`" do
          let(:object) { true }

          it "returns success result without data" do
            expect(result).to be_success.without_data.of_service(service).without_step
          end

          context "when `data_key` is passed" do
            let(:result) { step_aware_boolean.result(data_key: data_key) }

            let(:data_key) { :elements }

            it "is ignored" do
              expect(result).to be_success.without_data.of_service(service).without_step
            end
          end

          context "when `evaluate_by` is passed" do
            let(:result) { step_aware_boolean.result(evaluate_by: evaluate_by) }

            let(:evaluate_by) { :to_s }

            it "is ignored" do
              expect(result).to be_success.without_data.of_service(service).without_step
            end
          end
        end
      end

      context "when step aware boolean has propagated result" do
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

    describe "#default_data_key" do
      it "returns `nil`" do
        expect(step_aware_boolean.default_data_key).to be_nil
      end
    end

    describe "#default_evaluate_by" do
      it "returns `nil`" do
        expect(step_aware_boolean.default_evaluate_by).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
