# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Commands::CreateStepClass do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:command_result) { described_class.call(service_class: service_class) }

      let(:service_class) { Class.new }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity, :call)
          .with_arguments(namespace: service_class, proto_entity: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
