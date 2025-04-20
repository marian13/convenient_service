# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:attributes) { {data: data, message: message, code: code} }
  let(:data) { {foo: "bar"} }
  let(:message) { "foo" }
  let(:code) { :custom }

  example_group "instance methods" do
    describe "#success" do
      specify do
        expect { service_instance.success(**attributes) }
          .to delegate_to(service_class, :success)
          .with_arguments(**attributes.merge(service: service_instance))
          .and_return_its_value
      end
    end

    describe "#failure" do
      specify do
        expect { service_instance.failure(**attributes) }
          .to delegate_to(service_class, :failure)
          .with_arguments(**attributes.merge(service: service_instance))
          .and_return_its_value
      end
    end

    describe "#error" do
      specify do
        expect { service_instance.error(**attributes) }
          .to delegate_to(service_class, :error)
          .with_arguments(**attributes.merge(service: service_instance))
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
