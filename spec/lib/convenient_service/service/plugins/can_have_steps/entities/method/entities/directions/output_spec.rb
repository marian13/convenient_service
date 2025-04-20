# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Output, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:direction) { described_class.new }
  let(:options) { {direction: :output} }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Base) }
  end

  example_group "instance methods" do
    let(:service_class) { Class.new }
    let(:service_instance) { service_class.new }

    let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method
        .cast(:foo, **options)
        .copy(overrides: {kwargs: {organizer: organizer}})
    end

    describe "#define_output_in_container!" do
      let(:options) { {direction: :output} }
      let(:index) { 0 }

      it "returns `false`" do
        expect(direction.define_output_in_container!(container, index: 0, method: method)).to eq(false)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
