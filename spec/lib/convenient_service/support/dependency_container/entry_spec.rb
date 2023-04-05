# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Entry do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:container) do
    Module.new.tap do |mod|
      mod.module_exec(described_class) do |described_mod|
        include described_mod
      end
    end
  end

  let(:entry) { container.entry(name, &body) }

  let(:name) { :foo }
  let(:body) { proc { :bar } }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "class methods" do
    describe "#entry" do
      specify do
        expect { entry }
          .to delegate_to(ConvenientService::Support::DependencyContainer::Commands::DefineEntry, :call)
          .with_arguments(container: container, name: name, body: body)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
