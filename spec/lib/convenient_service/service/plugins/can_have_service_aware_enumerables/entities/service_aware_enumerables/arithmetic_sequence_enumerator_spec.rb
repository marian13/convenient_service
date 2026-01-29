# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ArithmeticSequenceEnumerator, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_aware_arithmetic_sequence_enumerator) { described_class.new(object: object, organizer: organizer, propagated_result: propagated_result) }

  let(:service) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:object) { (0..5).step(1) }
  let(:organizer) { service.new }
  let(:propagated_result) { service.error(code: "from propagated result") }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator) }
  end

  example_group "instance methods" do
    example_group "alias methods" do
      include ConvenientService::RSpec::Matchers::HaveAliasMethod

      subject { service_aware_arithmetic_sequence_enumerator }

      it { is_expected.to have_alias_method(:arithmetic_sequence_enumerator, :object) }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
