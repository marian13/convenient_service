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

  let(:step_aware_boolean) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { 42 }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::PrimitiveMatchers::HaveAliasMethod

      subject { step_aware_boolean }

      it { is_expected.to have_alias_method(:boolean, :object) }
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
