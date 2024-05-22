# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Commands::IsService, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(service: service) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Service::Configs::Essential

          def result
            success
          end
        end
      end

      let(:service) { service_class.new }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Commands::IsServiceClass, :call)
          .with_arguments(service_class: service.class)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
