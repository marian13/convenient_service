# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:step_aware_base) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { [:foo, :bar] }
  let(:organizer) { service.new }
  let(:propagated_result) { organizer.error(code: "from propagated result") }

  example_group "instance methods" do
    example_group "attributes" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

      subject { step_aware_base }

      it { is_expected.to have_attr_reader(:object) }
      it { is_expected.to have_attr_reader(:organizer) }
      it { is_expected.to have_attr_reader(:propagated_result) }
    end

    example_group "abstract methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod

      subject { step_aware_base }

      it { is_expected.to have_abstract_method(:default_data_key) }
      it { is_expected.to have_abstract_method(:evaluate_by) }
    end

    describe "#result" do
      let(:step_aware_klass) do
        Class.new(described_class) do
          def default_data_key
            :items
          end

          def default_evaluate_by
            :inspect
          end
        end
      end

      let(:step_aware_descendant) { step_aware_klass.new(object: object, organizer: organizer, propagated_result: propagated_result) }

      let(:data_key) { :elements }
      let(:evaluate_by) { :to_s }

      let(:result) { step_aware_descendant.result(data_key: data_key, evaluate_by: evaluate_by) }

      context "when step aware descendant does NOT have propagated result" do
        let(:propagated_result) { nil }

        it "returns result with data" do
          expect(result).to be_success.with_data(data_key => object.to_s).of_service(service).without_step
        end

        context "when `data_key` is NOT passed" do
          let(:result) { step_aware_descendant.result(evaluate_by: evaluate_by) }

          it "defaults to `default_data_key`" do
            expect(result).to be_success.with_data(step_aware_descendant.default_data_key => object.to_s).of_service(service).without_step
          end
        end

        context "when `data_key` is `nil`" do
          let(:data_key) { nil }

          it "returns result without data" do
            expect(result).to be_success.without_data.of_service(service).without_step
          end
        end

        context "when `evaluate_by` is NOT passed" do
          let(:result) { step_aware_descendant.result(data_key: data_key) }

          it "defaults to `default_evaluate_by`" do
            expect { result }
              .to delegate_to(object, step_aware_descendant.default_evaluate_by)
              .without_arguments
          end
        end
      end

      context "when step aware descendant has propagated result" do
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

    example_group "comparison" do
      describe "#==" do
        context "when `other` have different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(step_aware_base == other).to be_nil
          end
        end

        context "when `other` have different `object`" do
          let(:other) { described_class.new(object: {foo: :bar, baz: :qux}, organizer: organizer, propagated_result: propagated_result) }

          it "returns `false`" do
            expect(step_aware_base == other).to eq(false)
          end
        end

        context "when `other` have different `organizer`" do
          let(:other) { described_class.new(object: object, organizer: service.new, propagated_result: propagated_result) }

          it "returns `false`" do
            expect(step_aware_base == other).to eq(false)
          end
        end

        context "when `other` have different `propagated_result`" do
          let(:other) { described_class.new(object: object, organizer: organizer, propagated_result: service.failure) }

          it "returns `false`" do
            expect(step_aware_base == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

          it "returns `true`" do
            expect(step_aware_base == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
