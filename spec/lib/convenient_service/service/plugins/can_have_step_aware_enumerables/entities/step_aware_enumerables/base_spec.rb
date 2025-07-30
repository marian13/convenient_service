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

  let(:step_aware_base) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { [:foo, :bar] }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "instance methods" do
    example_group "abstract methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod

      subject { step_aware_base }

      it { is_expected.to have_abstract_method(:default_data_key) }
      it { is_expected.to have_abstract_method(:evaluate_by) }
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
