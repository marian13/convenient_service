# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_aware_enumerator) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { [:foo, :bar].each }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::Matchers::HaveAliasMethod

      subject { service_aware_enumerator }

      it { is_expected.to have_alias_method(:enumerator, :object) }
    end

    describe "#default_data_key" do
      it "returns `:values`" do
        expect(service_aware_enumerator.default_data_key).to eq(:values)
      end
    end

    describe "#default_evaluate_by" do
      it "returns `:to_h`" do
        expect(service_aware_enumerator.default_evaluate_by).to eq(:to_a)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
