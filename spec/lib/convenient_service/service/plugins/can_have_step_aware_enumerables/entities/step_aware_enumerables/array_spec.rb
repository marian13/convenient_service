# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Array, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_aware_array) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { [:foo, :bar] }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAliasMethod

      subject { step_aware_array }

      it { is_expected.to have_alias_method(:array, :object) }
    end

    describe "#default_data_key" do
      it "returns `:values`" do
        expect(step_aware_hash.default_data_key).to eq(:values)
      end
    end

    describe "#default_evaluate_by" do
      it "returns `:to_a`" do
        expect(step_aware_hash.default_evaluate_by).to eq(:to_a)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
