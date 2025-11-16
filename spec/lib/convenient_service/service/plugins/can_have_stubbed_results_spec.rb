# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".set_service_stubbed_result" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }
      let(:result) { service.error }

      specify do
        expect { described_class.set_service_stubbed_result(service, arguments, result) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult, :call)
          .with_arguments(service: service, arguments: arguments, result: result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
