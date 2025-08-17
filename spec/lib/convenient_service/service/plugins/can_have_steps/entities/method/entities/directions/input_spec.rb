# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:direction) { described_class.new }
  let(:options) { {direction: :input} }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

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

      let(:exception_message) do
        <<~TEXT
          Method `#{method.name}` is NOT an `out` method.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod`" do
        expect { direction.define_output_in_container!(container, index: index, method: method) }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod) { direction.define_output_in_container!(container, index: index, method: method) } }
          .to delegate_to(ConvenientService, :raise)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
